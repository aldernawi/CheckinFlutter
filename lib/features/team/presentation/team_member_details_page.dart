import 'package:flutter/material.dart';

class TeamMemberDetailsPage extends StatelessWidget {
  const TeamMemberDetailsPage({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الموظف')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Color(0xFFDC2626), child: Icon(Icons.person, size: 40, color: Colors.white)),
                const SizedBox(height: 12),
                Text(memberId, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('موظف ميداني', style: TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('حضور اليوم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRow('الحالة', 'حاضر', const Color(0xFF10B981)),
                  _buildRow('وقت الدخول', '08:30 ص', null),
                  _buildRow('وقت الخروج', '05:00 م', null),
                  _buildRow('ساعات العمل', '8 ساعات 30 دقيقة', null),
                  _buildRow('موقع الدخول', 'المكتب الرئيسي', null),
                  _buildRow('التأخير', '0 دقيقة', null),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إحصائيات الشهر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRow('أيام الحضور', '22 يوم', null),
                  _buildRow('أيام التأخير', '3 أيام', null),
                  _buildRow('أيام الغياب', '1 يوم', null),
                  _buildRow('الإجازات', '2 يوم', null),
                  _buildRow('نسبة الحضور', '95%', const Color(0xFF10B981)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}
