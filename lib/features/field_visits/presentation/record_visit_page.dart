import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:checkin_flutter/core/services/location_service.dart';
import 'package:checkin_flutter/features/field_visits/field_visits_repository.dart';
import 'package:checkin_flutter/features/stores/stores_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecordVisitPage extends ConsumerStatefulWidget {
  const RecordVisitPage({super.key, required this.storeId});

  final String storeId;

  @override
  ConsumerState<RecordVisitPage> createState() => _RecordVisitPageState();
}

class _RecordVisitPageState extends ConsumerState<RecordVisitPage> {
  bool _isLoading = true;
  bool _isLocating = false;
  bool _isRecording = false;
  String _storeName = '';
  String _storeAddress = '';
  String _locationStatus = 'جاري تحديد الموقع...';
  String _distanceText = '';
  bool _isWithinRange = false;
  double _currentLat = 0;
  double _currentLng = 0;
  double _storeLat = 0;
  double _storeLng = 0;
  double _accuracy = 0;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final response = await ref.read(storesRepositoryProvider).getStore(widget.storeId);
    if (mounted && response.success && response.data != null) {
      final s = response.data!;
      setState(() {
        _storeName = s.displayName;
        _storeAddress = [s.city, s.district].whereType<String>().join(' - ');
        _storeLat = s.latitude;
        _storeLng = s.longitude;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
    await _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLocating = true;
      _locationStatus = 'جاري تحديد الموقع...';
      _distanceText = '';
    });
    try {
      final position = await ref.read(locationServiceProvider).getCurrentLocation();
      final distance = ref.read(locationServiceProvider).distanceBetween(
        startLatitude: position.latitude,
        startLongitude: position.longitude,
        endLatitude: _storeLat,
        endLongitude: _storeLng,
      );
      final withinRange = distance <= 200;
      if (mounted) {
        setState(() {
          _isLocating = false;
          _currentLat = position.latitude;
          _currentLng = position.longitude;
          _accuracy = position.accuracy;
          _isWithinRange = withinRange;
          _locationStatus = withinRange ? 'داخل النطاق' : 'خارج النطاق';
          _distanceText = 'المسافة: ${distance.round()} متر';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLocating = false;
          _isWithinRange = false;
          _locationStatus = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('تسجيل زيارة')),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل زيارة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store, color: Color(0xFFDC2626)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_storeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_storeAddress, style: const TextStyle(color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isWithinRange ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    _isLocating ? Icons.location_searching : (_isWithinRange ? Icons.check_circle : Icons.location_off),
                    size: 48,
                    color: _isWithinRange ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                  ),
                  const SizedBox(height: 8),
                  Text(_locationStatus, style: TextStyle(fontWeight: FontWeight.w600, color: _isWithinRange ? const Color(0xFF10B981) : const Color(0xFF6B7280))),
                  if (_distanceText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(_distanceText, style: const TextStyle(color: Color(0xFF6B7280))),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_isLocating)
              TextButton.icon(
                onPressed: _loadLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث الموقع'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'ملاحظات (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC2626))),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isRecording || _isLocating || !_isWithinRange ? null : _recordVisit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isRecording
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('تسجيل الزيارة', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordVisit() async {
    setState(() => _isRecording = true);
    final response = await ref.read(fieldVisitsRepositoryProvider).recordVisit(
      RecordVisitRequest(
        storeId: widget.storeId,
        latitude: _currentLat,
        longitude: _currentLng,
        accuracy: _accuracy,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      ),
    );
    if (mounted) {
      setState(() => _isRecording = false);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الزيارة بنجاح')),
        );
        context.go('/fieldrep/visits');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error?.message ?? 'فشل تسجيل الزيارة')),
        );
      }
    }
  }
}
