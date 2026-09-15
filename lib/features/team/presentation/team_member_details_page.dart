import 'package:checkin_flutter/core/models/team_models.dart';
import 'package:checkin_flutter/features/team/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMemberDetailsPage extends ConsumerStatefulWidget {
  const TeamMemberDetailsPage({
    super.key,
    required this.memberId,
    this.initialMember,
  });

  final String memberId;
  final TeamMemberAttendanceDto? initialMember;

  @override
  ConsumerState<TeamMemberDetailsPage> createState() =>
      _TeamMemberDetailsPageState();
}

class _TeamMemberDetailsPageState extends ConsumerState<TeamMemberDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialMember == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(teamAttendanceProvider.notifier)
            .loadAttendance(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamAttendanceProvider);
    final matches = state.items.where((m) => m.employeeId == widget.memberId);
    final member =
        widget.initialMember ?? (matches.isEmpty ? null : matches.first);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الموظف')),
      body: member == null
          ? state.status == TeamLoadStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                      state.errorMessage ?? 'تعذر العثور على بيانات الموظف',
                    ),
                  )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFDC2626),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        member.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        member.employeeNumber,
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
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
                        const Text(
                          'حضور اليوم',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _row('الحالة', member.statusName),
                        _row('وقت الدخول', _time(member.checkInTime)),
                        _row('وقت الخروج', _time(member.checkOutTime)),
                        _row('مدة العمل', _minutes(member.workedMinutes)),
                        _row('التأخير', _minutes(member.lateMinutes)),
                        _row(
                          'موقع الدخول',
                          member.checkInLocation?.trim().isNotEmpty == true
                              ? member.checkInLocation!
                              : 'غير مسجل',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _time(DateTime? value) => value == null
      ? 'غير مسجل'
      : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String _minutes(int total) =>
      total < 60 ? '$total دقيقة' : '${total ~/ 60} س ${total % 60} د';

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
