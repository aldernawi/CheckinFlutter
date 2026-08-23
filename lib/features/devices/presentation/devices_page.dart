import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/devices/devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesPage extends ConsumerStatefulWidget {
  const DevicesPage({super.key});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(devicesProvider.notifier).loadDevices();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(devicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الأجهزة المسجلة')),
      body: state.status == DevicesLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == DevicesLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(devicesProvider.notifier).loadDevices(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(devicesProvider.notifier).loadDevices(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.devices, color: Color(0xFFDC2626)),
                              const SizedBox(width: 12),
                              Text('الأجهزة المسجلة: ${state.devices.length} / ${state.maxDevices}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...state.devices.map((d) => _buildDeviceCard(d)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDeviceCard(DeviceDto d) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(d.deviceType == 'iOS' ? Icons.phone_iphone : Icons.phone_android, color: const Color(0xFF6B7280)),
        title: Row(
          children: [
            Text(d.deviceName, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (d.isCurrentDevice) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(4)),
                child: const Text('هذا الجهاز', style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
              ),
            ],
          ],
        ),
        subtitle: Text('تاريخ التسجيل: ${_formatDate(d.registeredAt)}'),
        trailing: d.isCurrentDevice
            ? null
            : IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                onPressed: () => _revokeDevice(d),
              ),
      ),
    );
  }

  void _revokeDevice(DeviceDto d) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء تسجيل الجهاز'),
        content: Text('هل أنت متأكد من إلغاء تسجيل ${d.deviceName}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await ref.read(devicesProvider.notifier).revokeDevice(d.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'تم إلغاء التسجيل' : 'فشل إلغاء التسجيل')),
                );
              }
            },
            child: const Text('تأكيد', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}
