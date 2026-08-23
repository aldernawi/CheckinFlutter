import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key, this.initialLat, this.initialLng});

  final double? initialLat;
  final double? initialLng;

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late double _lat;
  late double _lng;
  bool _isLoading = true;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const _defaultLat = 32.8872;
  static const _defaultLng = 13.1913;

  @override
  void initState() {
    super.initState();
    _lat = widget.initialLat ?? _defaultLat;
    _lng = widget.initialLng ?? _defaultLng;
    _updateMarker();
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: LatLng(_lat, _lng),
          infoWindow: const InfoWindow(title: 'الموقع المحدد'),
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _isLoading = false);
  }

  void _onMapTapped(LatLng position) {
    _lat = position.latitude;
    _lng = position.longitude;
    _updateMarker();
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void _confirmLocation() {
    if (_lat == _defaultLat && _lng == _defaultLng) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد موقع على الخريطة')),
      );
      return;
    }
    Navigator.of(context).pop({'lat': _lat, 'lng': _lng});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد الموقع على الخريطة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: _confirmLocation,
            tooltip: 'تأكيد',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_lat, _lng),
              zoom: 14,
            ),
            onMapCreated: _onMapCreated,
            onTap: _onMapTapped,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: false,
          ),
          // Location info panel
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Color(0xFFDC2626)),
                      const SizedBox(width: 8),
                      const Text(
                        'الإحداثيات المحددة',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('خط العرض', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                            Text(_lat.toStringAsFixed(6), style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('خط الطول', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                            Text(_lng.toStringAsFixed(6), style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Color(0xFF6B7280)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'انقر على الخريطة لتحديد الموقع',
                            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),
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
}
