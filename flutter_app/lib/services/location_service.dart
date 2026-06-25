import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

/// Backend-side helper that resolves the device's current GPS position and
/// returns it as a Firestore [GeoPoint].
///
/// It is intentionally best-effort: it never throws and returns `null` whenever
/// the location cannot be obtained (location services disabled, permission
/// denied, or the lookup times out). Callers can therefore persist a scan with
/// or without a location without any extra error handling.
class LocationService {
  /// Resolves the current position. Returns `null` when unavailable.
  static Future<GeoPoint?> getCurrentGeoPoint() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          // Kept short so attaching a location never blows the scan-save budget.
          timeLimit: Duration(seconds: 5),
        ),
      );
      return GeoPoint(position.latitude, position.longitude);
    } catch (_) {
      // Location is best-effort; a scan must still save without it.
      return null;
    }
  }
}
