import 'package:checkin_flutter/core/models/attendance_models.dart';
import 'package:checkin_flutter/core/services/location_service.dart';
import 'package:checkin_flutter/core/services/device_identity_service.dart';
import 'package:checkin_flutter/features/attendance/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key});

  @override
  ConsumerState<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage> {
  bool _isLocating = false;
  bool _isSubmitting = false;
  String _locationStatus = 'جاري تحديد الموقع...';
  bool _isWithinRange = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determineLocation();
  }

  Future<void> _determineLocation() async {
    setState(() {
      _isLocating = true;
      _locationStatus = 'جاري تحديد الموقع...';
    });
    try {
      final position = await ref
          .read(locationServiceProvider)
          .getCurrentLocation();
      if (mounted) {
        setState(() {
          _isLocating = false;
          _currentPosition = position;
          _isWithinRange = true;
          _locationStatus = 'تم تحديد الموقع';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLocating = false;
          _isWithinRange = false;
          _locationStatus = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الحضور')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _isWithinRange
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isLocating
                    ? Icons.location_searching
                    : (_isWithinRange ? Icons.check : Icons.location_off),
                size: 48,
                color: _isWithinRange
                    ? const Color(0xFF10B981)
                    : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _locationStatus,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _isWithinRange
                    ? const Color(0xFF10B981)
                    : const Color(0xFF6B7280),
              ),
            ),
            const Spacer(),
            if (_isLocating)
              const CircularProgressIndicator(color: Color(0xFFDC2626))
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting || !_isWithinRange ? null : _checkIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'تسجيل الحضور',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/main/home'),
              child: const Text('إلغاء'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _checkIn() async {
    if (_currentPosition == null) return;
    setState(() => _isSubmitting = true);
    final device = await ref.read(deviceIdentityServiceProvider).getIdentity();
    final response = await ref
        .read(attendanceRepositoryProvider)
        .checkin(
          CheckinRequest(
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude,
            accuracy: _currentPosition!.accuracy,
            deviceId: device.id,
          ),
        );
    if (mounted) {
      setState(() => _isSubmitting = false);
      if (response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تسجيل الحضور بنجاح')));
        context.go('/main/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error?.message ?? 'فشل تسجيل الحضور'),
          ),
        );
      }
    }
  }
}
