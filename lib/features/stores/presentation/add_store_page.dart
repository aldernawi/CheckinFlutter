import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/field_visits/presentation/map_picker_page.dart';
import 'package:checkin_flutter/features/stores/stores_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStorePage extends ConsumerStatefulWidget {
  const AddStorePage({super.key});

  @override
  ConsumerState<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends ConsumerState<AddStorePage> {
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  double _lat = 32.8872;
  double _lng = 13.1911;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة محل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(_nameController, 'اسم المحل (إنجليزي)'),
            const SizedBox(height: 16),
            _buildField(_nameArController, 'اسم المحل (عربي)'),
            const SizedBox(height: 16),
            _buildField(_ownerController, 'اسم المالك'),
            const SizedBox(height: 16),
            _buildField(_phoneController, 'رقم الهاتف', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField(_cityController, 'المدينة'),
            const SizedBox(height: 16),
            _buildField(_districtController, 'الحي'),
            const SizedBox(height: 16),
            _buildField(_addressController, 'العنوان'),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFFDC2626)),
                title: const Text('الموقع'),
                subtitle: Text('$_lat, $_lng'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () async {
                  final result = await Navigator.of(context).push<Map<String, dynamic>>(
                    MaterialPageRoute(
                      builder: (_) => MapPickerPage(initialLat: _lat, initialLng: _lng),
                    ),
                  );
                  if (result != null) setState(() {_lat = result['lat'] as double; _lng = result['lng'] as double;});
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('حفظ المحل'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC2626))),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final response = await ref.read(storesRepositoryProvider).createStore(
      CreateStoreRequest(
        name: _nameController.text,
        nameAr: _nameArController.text.isEmpty ? null : _nameArController.text,
        ownerName: _ownerController.text.isEmpty ? null : _ownerController.text,
        ownerPhone1: _phoneController.text.isEmpty ? null : _phoneController.text,
        city: _cityController.text.isEmpty ? null : _cityController.text,
        district: _districtController.text.isEmpty ? null : _districtController.text,
        address: _addressController.text.isEmpty ? null : _addressController.text,
        latitude: _lat,
        longitude: _lng,
      ),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة المحل بنجاح')));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.error?.message ?? 'فشل إضافة المحل')));
      }
    }
  }
}
