import 'dart:math';

import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A stable, privacy-preserving identifier for one installation of the app.
///
/// It is generated once and kept in secure storage. This avoids using a
/// hard-coded value for every phone, while avoiding hardware identifiers that
/// may require extra permissions or create privacy concerns.
class DeviceIdentityService {
  DeviceIdentityService(this._storage);

  final SecureStorageService _storage;

  Future<DeviceIdentity> getIdentity() async {
    var id = await _storage.read(StorageKeys.deviceInstallationId);
    if (id == null || id.isEmpty) {
      id = _newUuidV4();
      await _storage.write(StorageKeys.deviceInstallationId, id);
    }

    final type = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 'iOS',
      TargetPlatform.android => 'Android',
      _ => 'Other',
    };
    return DeviceIdentity(
      id: id,
      name: 'Checkin $type (${id.substring(0, 8)})',
      type: type,
    );
  }

  String _newUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}

class DeviceIdentity {
  const DeviceIdentity({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;
}

final deviceIdentityServiceProvider = Provider<DeviceIdentityService>(
  (ref) => DeviceIdentityService(ref.watch(secureStorageServiceProvider)),
);
