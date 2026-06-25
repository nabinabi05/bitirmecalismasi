import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads [imageFile] to Firebase Storage under
  /// [folderName]/[userId]/<timestamp>.jpg and returns the download URL.
  Future<String?> uploadImage(
      File imageFile, String folderName, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('$folderName/$userId/$fileName');

      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      debugPrint('✅ GÖRSEL FIREBASE STORAGE\'A BAŞARIYLA YÜKLENDİ: $url');
      return url;
    } catch (e) {
      debugPrint('Error uploading to Firebase Storage: $e');
      rethrow;
    }
  }

  /// Deletes the image at [fileUrl] from Firebase Storage.
  Future<void> deleteImage(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting from Firebase Storage: $e');
    }
  }
}
