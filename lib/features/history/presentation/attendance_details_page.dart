import 'package:flutter/material.dart';

class AttendanceDetailsPage extends StatelessWidget {
  const AttendanceDetailsPage({super.key, required this.attendanceId});

  final String attendanceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحضور')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('15 يناير 2024', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRow('الحالة', 'حاضر', const Color(0xFF10B981)),
                  _buildRow('وقت الدخول', '08:30 ص', null),
                  _buildRow('وقت الخروج', '05:00 م', null),
                  _buildRow('ساعات العمل', '8 ساعات 30 دقيقة', null),
                  _buildRow('التأخير', '0 دقيقة', null),
                  _buildRow('الإضافي', '0 دقيقة', null),
                  _buildRow('موقع الدخول', 'المكتب الرئيسي', null),
                  _buildRow('موقع الخروج', 'المكتب الرئيسي', null),
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
