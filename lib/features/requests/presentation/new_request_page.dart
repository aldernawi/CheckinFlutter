import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/features/requests/requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewRequestPage extends ConsumerStatefulWidget {
  const NewRequestPage({super.key});

  @override
  ConsumerState<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends ConsumerState<NewRequestPage> {
  RequestType _selectedType = RequestType.leave;
  DateTime _selectedDate = DateTime.now();
  DateTime? _endDate;
  final _reasonController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 20),
            _buildDateField(
              label: 'تاريخ البداية',
              date: _selectedDate,
              onPicked: (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 16),
            if (_selectedType == RequestType.leave ||
                _selectedType == RequestType.remoteWork) ...[
              _buildDateField(
                label: 'تاريخ النهاية (اختياري)',
                date: _endDate,
                onPicked: (d) => setState(() => _endDate = d),
              ),
              const SizedBox(height: 16),
            ],
            _buildReasonField(),
            const SizedBox(height: 16),
            _buildDetailsField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع الطلب',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RequestType.values.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(_getTypeLabel(type)),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedType = type),
              selectedColor: const Color(0xFFDC2626),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getTypeLabel(RequestType type) {
    switch (type) {
      case RequestType.leave:
        return 'إجازة';
      case RequestType.attendanceCorrection:
        return 'تصحيح حضور';
      case RequestType.remoteWork:
        return 'عمل عن بُعد';
      case RequestType.shiftChange:
        return 'تغيير وردية';
      case RequestType.locationAdd:
        return 'إضافة موقع';
      case RequestType.exceptionalCheckin:
        return 'تسجيل استثنائي';
    }
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime> onPicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) onPicked(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                      : 'اختر التاريخ',
                  style: TextStyle(
                    color: date != null ? Colors.black87 : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'السبب',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reasonController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'اكتب سبب الطلب...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل إضافية (اختياري)',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _detailsController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'تفاصيل إضافية...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('إرسال الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة سبب الطلب')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final request = CreateRequestRequest(
      type: _selectedType,
      effectiveDate:
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      endDate: _endDate != null
          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
          : null,
      reason: _reasonController.text.trim(),
      details: _detailsController.text.trim().isNotEmpty ? _detailsController.text.trim() : null,
    );

    final success = await ref.read(requestsProvider.notifier).createRequest(request);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
        );
        context.go('/requests');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل إرسال الطلب')),
        );
      }
    }
  }
}
