import 'package:checkin_flutter/core/models/team_models.dart';
import 'package:checkin_flutter/features/team/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeamAttendancePage extends ConsumerStatefulWidget {
  const TeamAttendancePage({super.key});

  @override
  ConsumerState<TeamAttendancePage> createState() => _TeamAttendancePageState();
}

class _TeamAttendancePageState extends ConsumerState<TeamAttendancePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamAttendanceProvider.notifier).loadAttendance(_selectedDate);
    });
  }

  void _changeDate(int delta) {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: delta)));
    ref.read(teamAttendanceProvider.notifier).loadAttendance(_selectedDate);
  }

  Color _statusColor(TeamMemberAttendanceDto m) {
    switch (m.status) {
      case AttendanceStatus.early:
      case AttendanceStatus.present:
        return const Color(0xFF10B981);
      case AttendanceStatus.late:
      case AttendanceStatus.veryLate:
        return const Color(0xFFF59E0B);
      case AttendanceStatus.absent:
        return const Color(0xFFEF4444);
      case AttendanceStatus.holiday:
      case AttendanceStatus.leave:
        return const Color(0xFF3B82F6);
      case null:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamAttendanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('حضور الفريق')),
      body: state.status == TeamLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == TeamLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(teamAttendanceProvider.notifier).loadAttendance(_selectedDate),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(teamAttendanceProvider.notifier).loadAttendance(_selectedDate),
                  child: Column(
                    children: [
                      _buildDateNavigator(),
                      if (state.summary != null) _buildSummary(state.summary!),
                      Expanded(
                        child: state.items.isEmpty
                            ? const Center(child: Text('لا يوجد أعضاء في فريقك'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.items.length,
                                itemBuilder: (context, index) => _buildMemberCard(state.items[index]),
                              ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/manager/pending-requests'),
        backgroundColor: const Color(0xFFDC2626),
        child: const Icon(Icons.pending_actions, color: Colors.white),
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(-1),
          ),
          Column(
            children: [
              Text(_formatDate(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_dayName(_selectedDate), style: const TextStyle(color: Color(0xFF6B7280))),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _selectedDate.day >= DateTime.now().day &&
                    _selectedDate.month >= DateTime.now().month &&
                    _selectedDate.year >= DateTime.now().year
                ? null
                : () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(TeamAttendanceSummary s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildSummaryItem('الحاضرون', s.present, const Color(0xFF10B981)),
          _buildSummaryItem('المتأخرون', s.late, const Color(0xFFF59E0B)),
          _buildSummaryItem('الغائبون', s.absent, const Color(0xFFEF4444)),
          _buildSummaryItem('الإجازات', s.onLeave, const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(TeamMemberAttendanceDto m) {
    final color = _statusColor(m);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(m.displayName.isNotEmpty ? m.displayName.substring(0, 1) : '?', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        title: Text(m.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(m.checkInTime != null ? 'دخول: ${_formatTime(m.checkInTime)}' : 'لم يسجل'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(m.statusName, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            if (m.lateMinutes > 0) Text('+${m.lateMinutes} د', style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11)),
          ],
        ),
        onTap: () => context.go('/manager/team/${m.employeeId}'),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';
  String _dayName(DateTime d) {
    const names = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return names[d.weekday - 1];
  }
  String _monthName(int m) {
    const names = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return names[m - 1];
  }
}
