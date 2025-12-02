import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color _kAccent = Color(0xFF2AAE9E);

class PaymentPage extends StatefulWidget {
  final int amount;
  const PaymentPage({Key? key, this.amount = 0}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  int _amount = 0;
  String _method = 'QRIS';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  Future<void> _confirmPayment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isProcessing = false);

    // Simulate success
    if (!mounted) return;
    String message;
    if (_method == 'QRIS') {
      message = 'Silakan scan QRIS untuk menyelesaikan pembayaran.';
    } else if (_method == 'Virtual Account') {
      message =
          'Virtual Account: 1234 5678 9012. Gunakan bank Anda untuk transfer.';
    } else if (_method == 'Mobile Banking') {
      message =
          'Ikuti instruksi di aplikasi mobile banking Anda untuk menyelesaikan pembayaran.';
    } else {
      message =
          'Pembayaran sebesar Rp${_amount.toString()} berhasil via $_method.';
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permintaan Pembayaran'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to app shell (Booked tab) as a default
              context.go('/app?tab=1');
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.white,
        foregroundColor: _kAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Jumlah Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _amount > 0 ? _amount.toString() : '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Masukkan jumlah';
                  final n = int.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
                  if (n == null || n <= 0) return 'Jumlah tidak valid';
                  return null;
                },
                onChanged: (v) {
                  final n =
                      int.tryParse(v.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                  setState(() => _amount = n);
                },
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
                    title: const Text('QRIS (scan QR)'),
                    value: 'QRIS',
                    groupValue: _method,
                    onChanged: (v) => setState(() => _method = v ?? _method),
                  ),
                  RadioListTile<String>(
                    title: const Text('Virtual Account'),
                    value: 'Virtual Account',
                    groupValue: _method,
                    onChanged: (v) => setState(() => _method = v ?? _method),
                  ),
                  RadioListTile<String>(
                    title: const Text('Mobile Banking'),
                    value: 'Mobile Banking',
                    groupValue: _method,
                    onChanged: (v) => setState(() => _method = v ?? _method),
                  ),
                  RadioListTile<String>(
                    title: const Text('E-Wallet'),
                    value: 'E-Wallet',
                    groupValue: _method,
                    onChanged: (v) => setState(() => _method = v ?? _method),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _confirmPayment,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Bayar Sekarang'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
