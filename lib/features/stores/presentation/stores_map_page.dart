import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoresMapPage extends ConsumerStatefulWidget {
  const StoresMapPage({super.key});

  @override
  ConsumerState<StoresMapPage> createState() => _StoresMapPageState();
}

class _StoresMapPageState extends ConsumerState<StoresMapPage> {
  bool _isLoading = true;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  int _totalStores = 0;
  int _visitedToday = 0;
  int _unvisitedCount = 0;
  List<StoreListItemDto> _stores = [];

  static const _defaultLat = 32.8872;
  static const _defaultLng = 13.1913;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() => _isLoading = true);
    final response = await ref.read(storesRepositoryProvider).getMyStores();
    if (mounted) {
      if (response.success && response.data != null) {
        _stores = response.data!.stores;
        _totalStores = _stores.length;
        _visitedToday = _stores.where((s) => s.visitsCount > 0).length;
        _unvisitedCount = _totalStores - _visitedToday;

        _markers = _stores.map((store) {
          final color = store.visitsCount > 0
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueRed;
          return Marker(
            markerId: MarkerId(store.id),
            position: LatLng(store.latitude, store.longitude),
            infoWindow: InfoWindow(
              title: store.displayName,
              snippet: [store.city, store.ownerPhone1].whereType<String>().join(' - '),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(color),
          );
        }).toSet();
      }
      setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitAllStores();
  }

  void _fitAllStores() {
    if (_stores.isEmpty) return;

    final latitudes = _stores.map((s) => s.latitude).toList();
    final longitudes = _stores.map((s) => s.longitude).toList();

    final minLat = latitudes.reduce((a, b) => a < b ? a : b);
    final maxLat = latitudes.reduce((a, b) => a > b ? a : b);
    final minLng = longitudes.reduce((a, b) => a < b ? a : b);
    final maxLng = longitudes.reduce((a, b) => a > b ? a : b);

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  Future<void> _refresh() async {
    await _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة المحلات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(_defaultLat, _defaultLng),
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: false,
          ),
          // Legend
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendDot(const Color(0xFF10B981), 'تمت الزيارة'),
                    const SizedBox(width: 12),
                    _buildLegendDot(const Color(0xFFEF4444), 'لم تُزر'),
                  ],
                ),
              ),
            ),
          ),
          // Bottom stats panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStat('إجمالي المحلات', '$_totalStores', const Color(0xFFDC2626)),
                  _buildStat('تمت زيارتها اليوم', '$_visitedToday', const Color(0xFF10B981)),
                  _buildStat('لم تُزر', '$_unvisitedCount', const Color(0xFFF59E0B)),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFDC2626)),
                        SizedBox(height: 16),
                        Text('جاري تحميل الخريطة...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
