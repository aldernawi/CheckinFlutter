import 'package:checkin_flutter/core/widgets/app_logo.dart';
import 'package:checkin_flutter/features/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  List<BranchOption> _branches = const [];
  String? _branchId;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل كمندوب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AppLogo(size: 72)),
            const SizedBox(height: 16),
            const Text(
              'أنشئ حساباً جديداً',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildField(_nameController, 'الاسم الكامل', Icons.person_outline),
            const SizedBox(height: 16),
            _buildField(
              _phoneController,
              'رقم الهاتف',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildField(
              _emailController,
              'البريد الإلكتروني (اختياري)',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _branchId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'الفرع',
                prefixIcon: const Icon(Icons.account_tree_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _branches
                  .map(
                    (branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.displayName),
                    ),
                  )
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _branchId = value),
            ),
            const SizedBox(height: 16),
            _buildField(
              _passwordController,
              'كلمة المرور',
              Icons.lock_outline,
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFEF4444))),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('إنشاء حساب'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('لديك حساب؟ تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
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
    );
  }

  Future<void> _submit() async {
    if (_branchId == null) {
      setState(() => _error = 'يرجى اختيار الفرع');
      return;
    }
    setState(() => _isLoading = true);
    final result = await ref
        .read(authRepositoryProvider)
        .selfRegister(
          fullName: _nameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          branchId: _branchId!,
          email: _emailController.text.isEmpty ? null : _emailController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح')));
        context.go('/login');
      } else {
        setState(() => _error = result.error);
      }
    }
  }

  Future<void> _loadBranches() async {
    final branches = await ref
        .read(authRepositoryProvider)
        .getRegistrationBranches();
    if (!mounted) return;
    setState(() {
      _branches = branches.where((branch) => branch.id.isNotEmpty).toList();
      if (_branches.isEmpty) {
        _error = 'تعذر تحميل الفروع، تحقق من الاتصال ثم أعد المحاولة.';
      }
    });
  }
}
