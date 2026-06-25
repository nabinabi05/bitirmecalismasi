import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/plant_scan_model.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';
import 'location_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Users ---
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  // --- Plant Scans ---
  /// Adds a scan to the `plants` collection and returns the new document id
  /// (used to link the local Isar copy for offline/delete sync).
  ///
  /// The write happens immediately so the scan always appears in My Garden
  /// without waiting on GPS. The device's current position is then attached as
  /// a best-effort, non-blocking patch (the `location` GeoPoint field). If the
  /// location is unavailable (services off, permission denied, timeout) the
  /// scan simply stays without it.
  Future<String> addPlantScan(PlantScanModel scan) async {
    final ref = await _db.collection('plants').add(scan.toMap());
    if (scan.location == null) {
      unawaited(_attachLocation(ref));
    }
    return ref.id;
  }

  /// Best-effort background enrichment: resolves the device location and patches
  /// it onto an already-written scan. Never throws; failures are ignored.
  Future<void> _attachLocation(
    DocumentReference<Map<String, dynamic>> ref,
  ) async {
    try {
      final geo = await LocationService.getCurrentGeoPoint();
      if (geo != null) {
        await ref.update({'location': geo});
      }
    } catch (_) {
      // Location is optional; ignore any failure so it never affects the scan.
    }
  }

  /// Deletes a single scan document by its Firestore id.
  Future<void> deletePlantScan(String plantId) async {
    await _db.collection('plants').doc(plantId).delete();
  }

  /// Deletes all scans belonging to [userId] in one batched write.
  Future<void> clearAllPlantScans(String userId) async {
    final snapshot = await _db
        .collection('plants')
        .where('userId', isEqualTo: userId)
        .get();
    if (snapshot.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<PlantScanModel>> getUserPlantScans(String userId) {
    return _db.collection('plants')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
        final scans = snapshot.docs.map((doc) => PlantScanModel.fromMap(doc.data(), doc.id)).toList();
        // İstemci tarafında sıralama yapıyoruz (Firebase Composite Index hatasını önlemek için).
        // userId + date üzerinde orderBy kullanmak composite index gerektirir; index
        // yoksa sorgu hata fırlatır ve "My Garden" boş görünür.
        scans.sort((a, b) => b.date.compareTo(a.date));
        return scans;
      });
  }

  // --- Community Posts ---
  Future<void> addCommunityPost(CommunityPostModel post) async {
    await _db.collection('community_posts').add(post.toMap());
  }

  Future<void> deleteCommunityPost(String postId) async {
    // Delete the post document
    await _db.collection('community_posts').doc(postId).delete();
    
    // Cleanup associated comments
    final commentsSnapshot = await _db.collection('post_comments').where('postId', isEqualTo: postId).get();
    for (var doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<CommunityPostModel>> getCommunityPosts() {
    return _db.collection('community_posts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => CommunityPostModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> toggleLike(String postId, String userId) async {
    final docRef = _db.collection('community_posts').doc(postId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      
      final data = snapshot.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      final dislikedBy = List<String>.from(data['dislikedBy'] ?? []);
      
      int likesCount = data['likesCount'] ?? 0;
      int dislikesCount = data['dislikesCount'] ?? 0;

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
        likesCount--;
      } else {
        likedBy.add(userId);
        likesCount++;
        if (dislikedBy.contains(userId)) {
          dislikedBy.remove(userId);
          dislikesCount--;
        }
      }

      transaction.update(docRef, {
        'likedBy': likedBy,
        'dislikedBy': dislikedBy,
        'likesCount': likesCount,
        'dislikesCount': dislikesCount,
      });
    });
  }

  Future<void> toggleDislike(String postId, String userId) async {
    final docRef = _db.collection('community_posts').doc(postId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      
      final data = snapshot.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      final dislikedBy = List<String>.from(data['dislikedBy'] ?? []);
      
      int likesCount = data['likesCount'] ?? 0;
      int dislikesCount = data['dislikesCount'] ?? 0;

      if (dislikedBy.contains(userId)) {
        dislikedBy.remove(userId);
        dislikesCount--;
      } else {
        dislikedBy.add(userId);
        dislikesCount++;
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          likesCount--;
        }
      }

      transaction.update(docRef, {
        'likedBy': likedBy,
        'dislikedBy': dislikedBy,
        'likesCount': likesCount,
        'dislikesCount': dislikesCount,
      });
    });
  }

  // --- Comments ---
  Future<void> addComment(CommentModel comment) async {
    await _db.collection('post_comments').add(comment.toMap());
  }

  Future<void> deleteComment(String commentId) async {
    await _db.collection('post_comments').doc(commentId).delete();
  }

  Future<void> markAcceptedAnswer(String commentId, bool accepted) async {
    await _db.collection('post_comments').doc(commentId).update({
      'isAcceptedAnswer': accepted,
    });
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return _db.collection('post_comments')
      .where('postId', isEqualTo: postId)
      .snapshots()
      .map((snapshot) {
        final comments = snapshot.docs.map((doc) => CommentModel.fromMap(doc.data(), doc.id)).toList();
        comments.sort((a, b) {
          if (a.isAcceptedAnswer != b.isAcceptedAnswer) {
            return a.isAcceptedAnswer ? -1 : 1; // kabul edilenler en üste
          }
          return a.createdAt.compareTo(b.createdAt); // geri kalanlar tarihe göre
        });
        return comments;
      });
  }
}
