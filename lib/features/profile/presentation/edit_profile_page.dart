import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ref.read(profileProvider.notifier).loadProfile();
    if (!mounted) return;
    final employee = ref.read(profileProvider).employee;
    if (employee != null) {
      _nameController.text = employee.fullNameAr?.trim().isNotEmpty == true
          ? employee.fullNameAr!
          : employee.fullName;
      _phoneController.text = employee.phone;
      _emailController.text = employee.email ?? '';
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.employee == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'تعذر تحميل بيانات الحساب',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        _load();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFDC2626),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    _nameController,
                    'الاسم الكامل',
                    Icons.person_outline,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'الاسم مطلوب'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    _phoneController,
                    'رقم الهاتف',
                    Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'رقم الهاتف مطلوب'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    _emailController,
                    'البريد الإلكتروني',
                    Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('حفظ التغييرات'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final employee = ref.read(profileProvider).employee!;
    final editsArabicName = employee.fullNameAr?.trim().isNotEmpty == true;
    final result = await ref
        .read(profileProvider.notifier)
        .updateProfile(
          UpdateProfileRequest(
            fullName: editsArabicName ? null : _nameController.text.trim(),
            fullNameAr: editsArabicName ? _nameController.text.trim() : null,
            phone: _phoneController.text.trim(),
            email: email.isEmpty ? null : email,
          ),
        );
    if (!mounted) return;
    if (result.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ التغييرات')));
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'فشل حفظ التغييرات')),
      );
    }
  }
}
