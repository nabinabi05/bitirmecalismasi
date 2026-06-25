import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/scan_history.dart';

class DatabaseService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ScanHistorySchema],
      directory: dir.path,
    );
  }

  /// Inserts or updates a scan. When [scan] already has an [id] (Isar assigns
  /// it on the first put), the same record is updated.
  static Future<void> saveScan(ScanHistory scan) async {
    await isar.writeTxn(() async {
      await isar.scanHistorys.put(scan);
    });
  }

  /// Newest-first local scans for [userId] (one-shot read).
  static Future<List<ScanHistory>> getUserScans(String userId) async {
    return isar.scanHistorys
        .filter()
        .userIdEqualTo(userId)
        .sortByScanDateDesc()
        .findAll();
  }

  /// Reactive newest-first local scans for [userId]; used as the offline
  /// fallback for My Garden so deletes refresh the list automatically.
  static Stream<List<ScanHistory>> watchUserScans(String userId) {
    return isar.scanHistorys
        .filter()
        .userIdEqualTo(userId)
        .sortByScanDateDesc()
        .watch(fireImmediately: true);
  }

  /// Removes the local copy mirrored to Firestore doc [firestoreId]
  /// (keeps the cache in sync when a scan is deleted online).
  static Future<void> deleteByFirestoreId(String firestoreId) async {
    await isar.writeTxn(() async {
      await isar.scanHistorys
          .filter()
          .firestoreIdEqualTo(firestoreId)
          .deleteAll();
    });
  }

  /// Clears every local scan for [userId].
  static Future<void> clearForUser(String userId) async {
    await isar.writeTxn(() async {
      await isar.scanHistorys.filter().userIdEqualTo(userId).deleteAll();
    });
  }

  static Future<void> deleteScan(int id) async {
    await isar.writeTxn(() async {
      await isar.scanHistorys.delete(id);
    });
  }

  static Future<List<ScanHistory>> getAllScans() async {
    return await isar.scanHistorys.where().sortByScanDateDesc().findAll();
  }
}
