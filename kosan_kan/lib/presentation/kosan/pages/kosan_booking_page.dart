import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KosanBookingPage extends StatefulWidget {
  final Map<String, String>? item;
  const KosanBookingPage({Key? key, this.item}) : super(key: key);

  @override
  State<KosanBookingPage> createState() => _KosanBookingPageState();
}

class _KosanBookingPageState extends State<KosanBookingPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _months = 1;
  DateTime? _startDate;
  String _paymentMethod = 'Transfer Bank';
  bool _isProcessing = false;

  int _parsePrice(String? priceStr) {
    if (priceStr == null) return 0;
    final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    try {
      return int.parse(digits);
    } catch (_) {
      return 0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan nomor telepon harus diisi')),
      );
      return;
    }
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isProcessing = false);
    // placeholder: in real app call repository/usecase to create booking
    // Instead of immediately finalizing booking, navigate to payment detail
    // so user can complete payment for the booking.
    final item = widget.item;
    final priceStr = item != null ? item['price'] ?? 'Rp0' : 'Rp0';
    final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    final unitPrice = digits.isEmpty ? 0 : int.tryParse(digits) ?? 0;
    final total = unitPrice * _months;

    final bookingData = <String, String>{
      'title': item != null ? (item['title'] ?? '') : 'Kosan',
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'months': '$_months',
      'duration': '$_months bulan',
      'date': _startDate != null ? _formatDate(_startDate!) : '',
      'total': total.toString(),
    };

    // navigate to payment detail page with booking info
    context.push(
      '/payment/detail?method=${Uri.encodeComponent(_paymentMethod)}&amount=$total',
      extra: bookingData,
    );
  }

  String _formatDate(DateTime d) {
    // simple dd/MM/yyyy
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _formatRupiah(int amount) {
    if (amount == 0) return 'Rp 0';
    final s = amount.toString();
    final parts = <String>[];
    for (int i = s.length; i > 0; i -= 3) {
      final start = (i - 3) < 0 ? 0 : i - 3;
      parts.insert(0, s.substring(start, i));
    }
    return 'Rp ${parts.join('.')}';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final title = item != null ? item['title'] : 'Kosan';
    final priceStr = item != null ? item['price'] : 'Rp0';
    final unitPrice = _parsePrice(priceStr);
    final total = unitPrice * _months;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 84,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            priceStr ?? '',
                            style: const TextStyle(
                              color: Color(0xFF2AAE9E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tanggal Mulai',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 0)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pilih tanggal mulai',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _startDate == null ? '' : _formatDate(_startDate!),
                  ),
                ),
              ),
            ),

            const Text(
              'Durasi (bulan)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _months,
                    items: [1, 2, 3, 6, 12]
                        .map(
                          (m) => DropdownMenuItem(value: m, child: Text('$m')),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _months = v ?? 1),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Transfer Bank'),
                  value: 'Transfer Bank',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v ?? 'Transfer Bank'),
                ),
                RadioListTile<String>(
                  title: const Text('E-Wallet'),
                  value: 'E-Wallet',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v ?? 'E-Wallet'),
                ),
                RadioListTile<String>(
                  title: const Text('QRIS'),
                  value: 'QRIS',
                  groupValue: _paymentMethod,
                  onChanged: (v) =>
                      setState(() => _paymentMethod = v ?? 'QRIS'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga per bulan'),
                        Text(priceStr ?? ''),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const Text('Durasi'), Text('$_months bulan')],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_formatRupiah(total)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isProcessing ? null : _confirmBooking,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2AAE9E),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Lanjutkan ke Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }
}
