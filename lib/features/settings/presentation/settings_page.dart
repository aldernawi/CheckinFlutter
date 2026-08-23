import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'عام',
            [
              _buildItem(
                icon: Icons.language,
                title: 'اللغة',
                subtitle: 'العربية',
                onTap: () {},
              ),
              _buildItem(
                icon: Icons.notifications_outlined,
                title: 'الإشعارات',
                subtitle: 'مفعّلة',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'قانوني',
            [
              _buildItem(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                onTap: () => context.go('/privacy-policy'),
              ),
              _buildItem(
                icon: Icons.description_outlined,
                title: 'شروط الاستخدام',
                onTap: () => context.go('/terms-of-service'),
              ),
              _buildItem(
                icon: Icons.delete_outline,
                title: 'حذف الحساب',
                titleColor: const Color(0xFFEF4444),
                onTap: () => context.go('/delete-account'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            'حول',
            [
              _buildItem(
                icon: Icons.info_outline,
                title: 'إصدار التطبيق',
                subtitle: '1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? const Color(0xFFDC2626)),
      title: Text(title, style: TextStyle(color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_left, color: Color(0xFFD1D5DB)),
      onTap: onTap,
    );
  }
}
