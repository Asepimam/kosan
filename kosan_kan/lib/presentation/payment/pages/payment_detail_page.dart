import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kosan_kan/app/notifications.dart';

class PaymentDetailPage extends StatefulWidget {
  final String method;
  final int amount;
  final Map<String, String>? booking;

  const PaymentDetailPage({
    Key? key,
    required this.method,
    required this.amount,
    this.booking,
  }) : super(key: key);

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  String? _selectedProvider;
  late final String _qrisPayload;
  final GlobalKey _qrKey = GlobalKey();

  String _formatRupiah(dynamic value) {
    if (value == null) return 'Rp 0';
    int amount;
    if (value is int) {
      amount = value;
    } else {
      final digits = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
      amount = digits.isEmpty ? 0 : int.tryParse(digits) ?? 0;
    }
    if (amount == 0) return 'Rp 0';
    final s = amount.toString();
    final parts = <String>[];
    for (int i = s.length; i > 0; i -= 3) {
      final start = (i - 3) < 0 ? 0 : i - 3;
      parts.insert(0, s.substring(start, i));
    }
    return 'Rp ${parts.join('.')}'.replaceAll('. ', '.');
  }

  @override
  void initState() {
    super.initState();
    final ref = DateTime.now().millisecondsSinceEpoch;
    _qrisPayload =
        'QRIS|amount=${widget.amount}|ref=$ref|title=${widget.booking?['title'] ?? ''}';
  }

  Future<void> _launchProvider(String provider) async {
    Uri uri;
    if (provider == 'DANA') {
      uri = Uri.parse('dana://pay?amount=${widget.amount}');
    } else if (provider == 'GOPAY') {
      uri = Uri.parse('gopay://pay?amount=${widget.amount}');
    } else {
      uri = Uri.parse(
        'https://example.com/pay?provider=$provider&amount=${widget.amount}',
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aplikasi $provider tidak ditemukan.')),
      );
    }
  }

  Widget _buildEwallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Pilih E-Wallet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['DANA', 'GOPAY'].map((p) {
            final selected = _selectedProvider == p;
            return ChoiceChip(
              label: Text(p),
              selected: selected,
              onSelected: (_) => setState(() => _selectedProvider = p),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _selectedProvider == null
              ? null
              : () => _launchProvider(_selectedProvider!),
          child: const Text('Bayar via E-Wallet'),
        ),
      ],
    );
  }

  Widget _buildBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Transfer Bank',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Silakan transfer ke rekening virtual berikut:'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nama Bank: BCA'),
                const SizedBox(height: 6),
                const Text('Nomor VA: 1234 5678 9012'),
                const SizedBox(height: 6),
                Text('Jumlah: ${_formatRupiah(widget.amount)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Instruksi transfer tersalin')),
            );
          },
          child: const Text('Salin Instruksi'),
        ),
      ],
    );
  }

  Widget _buildQris() {
    final screenWidth = MediaQuery.of(context).size.width;
    final qrSize = math.min(260.0, screenWidth * 0.72);
    final qrInnerSize = math.max(160.0, qrSize - 40);
    final buttonWidth = math.max(100.0, (screenWidth - 48) / 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('QRIS', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: qrSize,
                    height: qrSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: RepaintBoundary(
                        key: _qrKey,
                        child: QrImageView(
                          data: _qrisPayload,
                          size: qrInnerSize,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Scan QR di kasir/atau aplikasi pembayaran kamu'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: _qrisPayload));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payload QRIS disalin')),
                  );
                },
                child: const Text('Salin Kode'),
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: _saveQrisImage,
                child: const Text('Simpan QR'),
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  // simulate paying via QRIS
                  hasNewBooking.value = true;
                  context.go('/app?tab=booked');
                },
                child: const Text('Simulasikan Pembayaran via QRIS'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveQrisImage() async {
    try {
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menemukan QR untuk disimpan')),
        );
        return;
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengenerate gambar QR')),
        );
        return;
      }
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/qris_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('QR tersimpan: ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan QR: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // responsive layout handled below; theme not required here

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pembayaran'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Metode: ${widget.method}'),
            const SizedBox(height: 16),
            if (widget.method == 'E-Wallet')
              _buildEwallet()
            else if (widget.method == 'QRIS')
              _buildQris()
            else
              _buildBank(),
            const SizedBox(height: 20),
            if (widget.booking != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Detail Booking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Kosan: ${widget.booking?['title'] ?? '-'}'),
              Text('Nama: ${widget.booking?['name'] ?? '-'}'),
              Text(
                'Tanggal: ${widget.booking?['date'] ?? widget.booking?['checkin'] ?? '-'}',
              ),
              Text('Durasi: ${widget.booking?['duration'] ?? '-'}'),
              Builder(
                builder: (context) {
                  final invoice =
                      widget.booking?['invoice'] ??
                      'INV${DateTime.now().millisecondsSinceEpoch}';
                  final rawTotal =
                      widget.booking?['total'] ?? widget.amount.toString();
                  final formattedTotal = _formatRupiah(rawTotal);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice: $invoice'),
                      Text('Total: $formattedTotal'),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simulate successful payment and finalize booking
                hasNewBooking.value = true;
                // Navigate back to app and open Booked tab
                context.go('/app?tab=booked');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pembayaran sukses — booking selesai'),
                  ),
                );
              },
              child: const Text('Simulasikan Pembayaran Sukses'),
            ),
          ],
        ),
      ),
    );
  }
}
