import 'package:checkin_flutter/features/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        color: const Color(0xFFDC2626),
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(state)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLocationCard(state),
                    const SizedBox(height: 16),
                    _buildAttendanceCard(state),
                    if (state.isCheckedIn) ...[
                      const SizedBox(height: 16),
                      _buildQuickStats(state),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
      decoration: const BoxDecoration(
        color: Color(0xFFDC2626),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحباً،',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.employeeName.isEmpty ? 'الموظف' : state.employeeName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (state.shiftInfo.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      state.shiftInfo,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  state.currentTime,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.currentDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(HomeState state) {
    final statusColor = state.isWithinRange
        ? const Color(0xFF10B981)
        : const Color(0xFF9CA3AF);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'الموقع الحالي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => ref.read(homeProvider.notifier).refresh(),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      state.isWithinRange ? Icons.check : Icons.location_searching,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.locationStatus,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                        if (state.locationName.isNotEmpty)
                          Text(
                            state.locationName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        if (state.distanceText.isNotEmpty)
                          Text(
                            state.distanceText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state.isLocationLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFFDC2626),
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(HomeState state) {
    final buttonText = state.isCheckedIn && !state.isCheckedOut
        ? 'تسجيل الانصراف'
        : state.isCheckedIn && state.isCheckedOut
            ? 'تم تسجيل الانصراف'
            : 'تسجيل الحضور';

    final buttonColor = state.isCheckedIn && !state.isCheckedOut
        ? const Color(0xFFEF4444)
        : state.isCheckedIn && state.isCheckedOut
            ? const Color(0xFF9CA3AF)
            : const Color(0xFF10B981);

    final buttonEnabled = !state.isCheckedOut && !state.isActionLoading;

    final statusText = state.isCheckedIn && state.isCheckedOut
        ? 'تم تسجيل الحضور والانصراف'
        : state.isCheckedIn
            ? 'تم تسجيل الحضور'
            : 'لم يتم تسجيل الحضور بعد';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fact_check_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'حالة اليوم',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: buttonEnabled
                    ? () => _performAttendanceAction()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isActionLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(HomeState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'وقت الحضور',
            state.checkInTime ?? '--:--',
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            state.isCheckedOut ? 'وقت الانصراف' : 'بانتظار الانصراف',
            state.checkOutTime ?? '--:--',
            state.isCheckedOut ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performAttendanceAction() async {
    await ref.read(homeProvider.notifier).performAttendanceAction(
          latitude: 32.8872,
          longitude: 13.1913,
          accuracy: 10.0,
          deviceId: 'flutter-device-id',
        );
  }
}
