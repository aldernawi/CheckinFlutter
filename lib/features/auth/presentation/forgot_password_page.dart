import 'package:checkin_flutter/core/widgets/app_logo.dart';
import 'package:checkin_flutter/features/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _success = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة المرور')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AppLogo(size: 72)),
            const SizedBox(height: 16),
            const Text(
              'أدخل رقم هاتفك لإعادة تعيين كلمة المرور',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '09XXXXXXXX',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDC2626)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_success) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'تم إرسال تعليمات إعادة التعيين إلى رقم هاتفك',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF10B981)),
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('إرسال'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('العودة لتسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_phoneController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    final result = await ref.read(authRepositoryProvider).forgotPassword(_phoneController.text);
    if (mounted) setState(() {_isLoading = false; _success = result.success;});
  }
}
