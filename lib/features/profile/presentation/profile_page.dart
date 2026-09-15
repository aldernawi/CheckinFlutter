import 'package:checkin_flutter/features/auth/auth_repository.dart';
import 'package:checkin_flutter/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final employee = state.employee;

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(profileProvider.notifier).loadProfile(forceRefresh: true),
        child: employee == null && state.status == ProfileLoadStatus.loading
            ? ListView(
                children: const [
                  SizedBox(height: 260),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : employee == null
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 160),
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'تعذر تحميل الملف الشخصي',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref
                        .read(profileProvider.notifier)
                        .loadProfile(forceRefresh: true),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFDC2626),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employee.fullNameAr?.trim().isNotEmpty == true
                        ? employee.fullNameAr!
                        : employee.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.jobTitle?.trim().isNotEmpty == true
                        ? employee.jobTitle!
                        : employee.employeeNumber,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'تُعرض آخر بيانات محفوظة. ${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _menu(Icons.edit_outlined, 'تعديل الملف الشخصي', () async {
                    await context.push('/edit-profile');
                    if (mounted) {
                      await ref
                          .read(profileProvider.notifier)
                          .loadProfile(forceRefresh: true);
                    }
                  }),
                  _menu(
                    Icons.lock_outline,
                    'تغيير كلمة المرور',
                    () => context.push('/change-password'),
                  ),
                  _menu(
                    Icons.phone_android_outlined,
                    'الأجهزة المسجلة',
                    () => context.push('/devices'),
                  ),
                  _menu(
                    Icons.settings_outlined,
                    'الإعدادات',
                    () => context.push('/settings'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref.read(authRepositoryProvider).logout();
                        if (context.mounted) context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('تسجيل الخروج'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _menu(IconData icon, String title, VoidCallback onTap) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: Icon(icon, color: const Color(0xFFDC2626)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
    ),
  );
}
