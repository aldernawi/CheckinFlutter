import 'dart:async';

import 'package:checkin_flutter/core/models/attendance_models.dart';
import 'package:checkin_flutter/features/attendance/attendance_repository.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_item.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeLoadStatus { idle, loading, success, error }

class HomeState {
  const HomeState({
    required this.status,
    this.employeeName = '',
    this.shiftInfo = '',
    this.currentTime = '',
    this.currentDate = '',
    this.attendanceStatus,
    this.isCheckedIn = false,
    this.isCheckedOut = false,
    this.checkInTime,
    this.checkOutTime,
    this.locationStatus = 'جاري تحديد الموقع...',
    this.locationName = '',
    this.distanceText = '',
    this.isWithinRange = false,
    this.isLocationLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
  });

  final HomeLoadStatus status;
  final String employeeName;
  final String shiftInfo;
  final String currentTime;
  final String currentDate;
  final AttendanceStatusResponse? attendanceStatus;
  final bool isCheckedIn;
  final bool isCheckedOut;
  final String? checkInTime;
  final String? checkOutTime;
  final String locationStatus;
  final String locationName;
  final String distanceText;
  final bool isWithinRange;
  final bool isLocationLoading;
  final bool isActionLoading;
  final String? errorMessage;

  HomeState copyWith({
    HomeLoadStatus? status,
    String? employeeName,
    String? shiftInfo,
    String? currentTime,
    String? currentDate,
    AttendanceStatusResponse? attendanceStatus,
    bool? isCheckedIn,
    bool? isCheckedOut,
    String? checkInTime,
    String? checkOutTime,
    String? locationStatus,
    String? locationName,
    String? distanceText,
    bool? isWithinRange,
    bool? isLocationLoading,
    bool? isActionLoading,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      employeeName: employeeName ?? this.employeeName,
      shiftInfo: shiftInfo ?? this.shiftInfo,
      currentTime: currentTime ?? this.currentTime,
      currentDate: currentDate ?? this.currentDate,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isCheckedOut: isCheckedOut ?? this.isCheckedOut,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      locationStatus: locationStatus ?? this.locationStatus,
      locationName: locationName ?? this.locationName,
      distanceText: distanceText ?? this.distanceText,
      isWithinRange: isWithinRange ?? this.isWithinRange,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: errorMessage,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this._attendanceRepo, this._offlineQueue)
    : super(const HomeState(status: HomeLoadStatus.idle));

  final AttendanceRepository _attendanceRepo;
  final OfflineQueueRepository _offlineQueue;
  Timer? _timeTimer;

  Future<void> initialize() async {
    state = state.copyWith(status: HomeLoadStatus.loading);
    _startTimeUpdater();
    await _loadAttendanceStatus();
    state = state.copyWith(status: HomeLoadStatus.success);
  }

  void _startTimeUpdater() {
    _updateTime();
    _timeTimer?.cancel();
    _timeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTime(),
    );
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _formatArabicDate(now);
    state = state.copyWith(currentTime: timeStr, currentDate: dateStr);
  }

  String _formatArabicDate(DateTime date) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    const weekdays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return '${weekdays[date.weekday - 1]}، ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _loadAttendanceStatus() async {
    final response = await _attendanceRepo.getStatus();

    if (response.success && response.data != null) {
      final data = response.data!;
      final shift = data.shift;
      final shiftStr = shift != null
          ? '${shift.name}: ${shift.startTime} - ${shift.endTime}'
          : 'لا توجد وردية محددة';

      state = state.copyWith(
        attendanceStatus: data,
        isCheckedIn: data.isCheckedIn,
        isCheckedOut: data.isCheckedOut,
        checkInTime: data.checkInTime != null
            ? '${data.checkInTime!.hour.toString().padLeft(2, '0')}:${data.checkInTime!.minute.toString().padLeft(2, '0')}'
            : null,
        checkOutTime: data.checkOutTime != null
            ? '${data.checkOutTime!.hour.toString().padLeft(2, '0')}:${data.checkOutTime!.minute.toString().padLeft(2, '0')}'
            : null,
        shiftInfo: shiftStr,
      );
    }
  }

  Future<void> refresh() async {
    await _loadAttendanceStatus();
  }

  Future<void> performAttendanceAction({
    required double latitude,
    required double longitude,
    required double accuracy,
    required String deviceId,
  }) async {
    state = state.copyWith(isActionLoading: true);

    final nearby = await _attendanceRepo.getNearbyLocations(
      latitude,
      longitude,
    );
    final locations =
        nearby.data?.items.where((item) => item.isWithinRange).toList() ??
        const [];
    final location = locations.isEmpty ? null : locations.first;
    if (!nearby.success || location == null) {
      state = state.copyWith(
        isActionLoading: false,
        isWithinRange: false,
        locationStatus: nearby.error?.message ?? 'أنت خارج نطاق موقع العمل',
        errorMessage: nearby.error?.message ?? 'أنت خارج نطاق موقع العمل',
      );
      return;
    }
    state = state.copyWith(
      isWithinRange: true,
      locationName: location.nameAr ?? location.name,
      distanceText: '${location.distanceInMeters.toStringAsFixed(0)} م',
      locationStatus: 'داخل نطاق ${location.nameAr ?? location.name}',
    );

    final request = CheckinRequest(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      deviceId: deviceId,
    );

    if (!state.isCheckedIn) {
      final response = await _attendanceRepo.checkin(request);
      if (response.success && response.data != null) {
        await _loadAttendanceStatus();
      } else {
        if (await _queueIfNetworkFailure(
          'attendance.checkin',
          request.toJson(),
          response.error?.code,
        )) {
          return;
        }
        state = state.copyWith(
          isActionLoading: false,
          errorMessage: response.error?.message ?? 'فشل تسجيل الحضور',
        );
        return;
      }
    } else if (!state.isCheckedOut) {
      final response = await _attendanceRepo.checkout(request);
      if (response.success && response.data != null) {
        await _loadAttendanceStatus();
      } else {
        if (await _queueIfNetworkFailure(
          'attendance.checkout',
          request.toJson(),
          response.error?.code,
        )) {
          return;
        }
        state = state.copyWith(
          isActionLoading: false,
          errorMessage: response.error?.message ?? 'فشل تسجيل الانصراف',
        );
        return;
      }
    }

    state = state.copyWith(isActionLoading: false);
  }

  Future<bool> _queueIfNetworkFailure(
    String operation,
    Map<String, dynamic> payload,
    String? errorCode,
  ) async {
    if (errorCode != 'NETWORK_ERROR') return false;
    await _offlineQueue.enqueue(
      OfflineQueueItem(
        id: '$operation-${DateTime.now().microsecondsSinceEpoch}',
        feature: 'attendance',
        operation: operation,
        payload: {
          ...payload,
          'isOffline': true,
          'localTimestamp': DateTime.now().toIso8601String(),
        },
        createdAt: DateTime.now(),
        status: OfflineQueueStatus.pending,
      ),
    );
    state = state.copyWith(
      isActionLoading: false,
      errorMessage: 'تم حفظ العملية للمزامنة عند عودة الاتصال',
    );
    return true;
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    super.dispose();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    ref.watch(attendanceRepositoryProvider),
    ref.watch(offlineQueueRepositoryProvider),
  ),
);
