import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  final _passwordController = TextEditingController();
  final _feedbackController = TextEditingController();
  AccountDeletionReason? _selectedReason;
  bool _isLoading = false;

  static const _reasons = [
    (AccountDeletionReason.resignation, 'استقالة من العمل'),
    (AccountDeletionReason.noLongerNeeded, 'لم أعد بحاجة للحساب'),
    (AccountDeletionReason.privacyConcerns, 'مخاوف تتعلق بالخصوصية'),
    (AccountDeletionReason.other, 'سبب آخر'),
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حذف الحساب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text(
              'تحذير: حذف الحساب لا يمكن التراجع عنه',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم حذف جميع بياناتك نهائياً. تأكد من أنك متأكد قبل المتابعة.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            const Text('سبب الحذف', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            RadioGroup<AccountDeletionReason>(
              groupValue: _selectedReason,
              onChanged: (v) => setState(() => _selectedReason = v),
              child: Column(
                children: _reasons.map((r) => RadioListTile<AccountDeletionReason>(
                      value: r.$1,
                      title: Text(r.$2),
                      contentPadding: EdgeInsets.zero,
                    )).toList(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEF4444))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'ملاحظات إضافية (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEF4444))),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading || _selectedReason == null || _passwordController.text.isEmpty ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('حذف الحساب نهائياً'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final result = await ref.read(profileProvider.notifier).deleteAccount(
      password: _passwordController.text,
      reason: _selectedReason!,
      feedback: _feedbackController.text.isEmpty ? null : _feedbackController.text,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تقديم طلب حذف الحساب')));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.error ?? 'فشل حذف الحساب')));
      }
    }
  }
}
