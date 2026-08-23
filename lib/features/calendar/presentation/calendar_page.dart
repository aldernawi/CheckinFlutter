import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/calendar/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(calendarProvider.notifier).loadCalendar(_focusedDate.year, _focusedDate.month);
    });
  }

  void _changeMonth(int delta) {
    setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + delta, 1));
    ref.read(calendarProvider.notifier).loadCalendar(_focusedDate.year, _focusedDate.month);
  }

  CalendarDayDto? _findDay(List<CalendarDayDto> days, DateTime date) {
    for (final d in days) {
      if (d.date.year == date.year && d.date.month == date.month && d.date.day == date.day) {
        return d;
      }
    }
    return null;
  }

  Color _statusColor(CalendarDayDto? d) {
    if (d == null) return const Color(0xFF6B7280);
    switch (d.status) {
      case 1:
        return const Color(0xFF10B981);
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFFEF4444);
      case 4:
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _statusText(CalendarDayDto? d) {
    if (d == null) return 'لا توجد بيانات';
    switch (d.status) {
      case 0:
        return 'لا توجد بيانات';
      case 1:
        return 'حاضر';
      case 2:
        return 'متأخر';
      case 3:
        return 'غائب';
      case 4:
        return 'إجازة';
      default:
        return 'غير معروف';
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('التقويم')),
      body: state.status == CalendarLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == CalendarLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(calendarProvider.notifier).loadCalendar(_focusedDate.year, _focusedDate.month),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Text(
                            '${_monthName(_focusedDate.month)} ${_focusedDate.year}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ),
                    _buildCalendarGrid(state.days),
                    const Divider(),
                    _buildSelectedDayInfo(state.days),
                  ],
                ),
    );
  }

  Widget _buildCalendarGrid(List<CalendarDayDto> days) {
    final firstDay = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDay = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final startWeekday = (firstDay.weekday % 7);
    final daysCount = lastDay.day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: ['سبت', 'أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة']
                .map((d) => Expanded(child: Center(child: Padding(padding: const EdgeInsets.all(8), child: Text(d, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600))))))
                .toList(),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: startWeekday + daysCount,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox();
              final day = index - startWeekday + 1;
              final date = DateTime(_focusedDate.year, _focusedDate.month, day);
              final dayDto = _findDay(days, date);
              final color = _statusColor(dayDto);
              final hasData = dayDto != null && dayDto.status != 0;
              final isSelected = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFDC2626) : (hasData ? color.withValues(alpha: 0.1) : null),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: const Color(0xFFDC2626), width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected ? Colors.white : (hasData ? color : Colors.black87),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayInfo(List<CalendarDayDto> days) {
    final dayDto = _findDay(days, _selectedDate);
    final color = _statusColor(dayDto);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (dayDto != null && dayDto.status != 0) ...[
                Row(
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(_statusText(dayDto), style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('دخول: ${_formatTime(dayDto.checkInTime)}', style: const TextStyle(color: Color(0xFF6B7280))),
                Text('خروج: ${_formatTime(dayDto.checkOutTime)}', style: const TextStyle(color: Color(0xFF6B7280))),
                if (dayDto.lateMinutes > 0) Text('التأخير: ${dayDto.lateMinutes} دقيقة', style: const TextStyle(color: Color(0xFFF59E0B))),
                if (dayDto.workedMinutes > 0) Text('ساعات العمل: ${dayDto.workedMinutes} دقيقة', style: const TextStyle(color: Color(0xFF6B7280))),
              ] else
                const Text('لا توجد بيانات', style: TextStyle(color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    return names[month - 1];
  }
}
