import 'package:isar/isar.dart';

part 'scan_history.g.dart';

/// Local (offline) copy of a scan, stored in Isar. Mirrors the Firestore
/// `plants` document but keeps the image as a local file path so My Garden
/// can still show the photo with no network connection.
@collection
class ScanHistory {
  Id id = Isar.autoIncrement;

  /// Signed-in user's uid; keeps the local cache per-account.
  @Index()
  late String userId;

  /// Local file path of the captured photo (persisted under app documents).
  late String imagePath;

  /// Firebase Storage download URL once the cloud upload succeeds.
  String? cloudImageUrl;

  late String plantType;

  late String diseaseName;

  /// Raw model label, e.g. "Apple___Apple_scab" — drives the treatment sheet.
  late String rawLabel;

  late double confidence;

  late DateTime scanDate;

  /// Firestore document id of the mirrored cloud record; used to keep the
  /// local cache in sync when a scan is deleted online.
  @Index()
  String? firestoreId;
}
