import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditStorePage extends ConsumerStatefulWidget {
  const EditStorePage({super.key, required this.storeId});

  final String storeId;

  @override
  ConsumerState<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends ConsumerState<EditStorePage> {
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  double _storeLat = 0;
  double _storeLng = 0;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  Future<void> _loadStore() async {
    setState(() => _isLoading = true);
    final response = await ref.read(storesRepositoryProvider).getStore(widget.storeId);
    if (mounted) {
      setState(() => _isLoading = false);
      if (response.success && response.data != null) {
        final s = response.data!;
        _nameController.text = s.displayName;
        _ownerController.text = s.ownerName ?? '';
        _phoneController.text = s.ownerPhone1 ?? '';
        _cityController.text = s.city ?? '';
        _addressController.text = s.district ?? '';
        _storeLat = s.latitude;
        _storeLng = s.longitude;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('تعديل المحل')),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626))),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل المحل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(_nameController, 'اسم المحل'),
            const SizedBox(height: 16),
            _buildField(_ownerController, 'اسم المالك'),
            const SizedBox(height: 16),
            _buildField(_phoneController, 'رقم الهاتف', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField(_cityController, 'المدينة'),
            const SizedBox(height: 16),
            _buildField(_addressController, 'العنوان'),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('حفظ التغييرات'),
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
    setState(() => _isSaving = true);
    final response = await ref.read(storesRepositoryProvider).updateStore(
      widget.storeId,
      CreateStoreRequest(
        name: _nameController.text,
        ownerName: _ownerController.text.isEmpty ? null : _ownerController.text,
        ownerPhone1: _phoneController.text.isEmpty ? null : _phoneController.text,
        city: _cityController.text.isEmpty ? null : _cityController.text,
        address: _addressController.text.isEmpty ? null : _addressController.text,
        latitude: _storeLat,
        longitude: _storeLng,
      ),
    );
    if (mounted) {
      setState(() => _isSaving = false);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التغييرات')));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.error?.message ?? 'فشل حفظ التغييرات')));
      }
    }
  }
}
