import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/devices/devices_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DevicesLoadStatus { idle, loading, success, error }

class DevicesState {
  const DevicesState({
    required this.status,
    this.devices = const [],
    this.maxDevices = 2,
    this.errorMessage,
  });

  final DevicesLoadStatus status;
  final List<DeviceDto> devices;
  final int maxDevices;
  final String? errorMessage;

  DevicesState copyWith({
    DevicesLoadStatus? status,
    List<DeviceDto>? devices,
    int? maxDevices,
    String? errorMessage,
  }) {
    return DevicesState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      maxDevices: maxDevices ?? this.maxDevices,
      errorMessage: errorMessage,
    );
  }
}

class DevicesNotifier extends StateNotifier<DevicesState> {
  DevicesNotifier(this._repo) : super(const DevicesState(status: DevicesLoadStatus.idle));

  final DevicesRepository _repo;

  Future<void> loadDevices() async {
    state = state.copyWith(status: DevicesLoadStatus.loading);
    final response = await _repo.getDevices();

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: DevicesLoadStatus.success,
        devices: response.data!.devices,
        maxDevices: response.data!.maxDevices,
      );
    } else {
      state = state.copyWith(
        status: DevicesLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل الأجهزة',
      );
    }
  }

  Future<bool> revokeDevice(String deviceId) async {
    final response = await _repo.revokeDevice(deviceId);
    if (response.success) {
      await loadDevices();
      return true;
    }
    return false;
  }
}

final devicesProvider = StateNotifierProvider<DevicesNotifier, DevicesState>(
  (ref) => DevicesNotifier(ref.watch(devicesRepositoryProvider)),
);
