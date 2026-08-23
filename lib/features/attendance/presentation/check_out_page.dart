import 'package:checkin_flutter/core/models/attendance_models.dart';
import 'package:checkin_flutter/core/services/device_identity_service.dart';
import 'package:checkin_flutter/features/attendance/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckOutPage extends ConsumerStatefulWidget {
  const CheckOutPage({super.key});

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الانصراف')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'هل تريد تسجيل الانصراف؟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم إنهاء يوم العمل الحالي',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _checkOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
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
                        'تأكيد الانصراف',
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

  Future<void> _checkOut() async {
    setState(() => _isSubmitting = true);
    final device = await ref.read(deviceIdentityServiceProvider).getIdentity();
    final response = await ref
        .read(attendanceRepositoryProvider)
        .checkout(
          CheckinRequest(
            latitude: 32.8872,
            longitude: 13.1911,
            accuracy: 10,
            deviceId: device.id,
          ),
        );
    if (mounted) {
      setState(() => _isSubmitting = false);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الانصراف بنجاح')),
        );
        context.go('/main/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error?.message ?? 'فشل تسجيل الانصراف'),
          ),
        );
      }
    }
  }
}
