import 'package:flutter/material.dart';

class ServerErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final String message;

  const ServerErrorPage({
    Key? key,
    this.onRetry,
    this.message = 'Terjadi kesalahan pada server. Silakan coba lagi.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Error'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/server_error_image.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onRetry ?? () => Navigator.of(context).pop(),
                  child: const Text('Coba Lagi'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Kembali'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
