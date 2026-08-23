import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة. يرجى تفعيل GPS من الإعدادات.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('تم رفض إذن الموقع. يرجى السماح بالوصول للموقع.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('إذن الموقع مرفوض نهائياً. يرجى تفعيله من إعدادات التطبيق.');
    }

    return true;
  }

  Future<Position> getCurrentLocation({
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    await ensurePermission();
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  double distanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
