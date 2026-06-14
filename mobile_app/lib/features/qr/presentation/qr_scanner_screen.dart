import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isScanning = false;
  bool _showResult = false;

  void _simulateScan() async {
    setState(() {
      _isScanning = true;
      _showResult = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isScanning = false;
        _showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Arahkan kamera ke QR Code pada buku untuk membuka informasi koleksi. Saat ini masih berupa simulasi frontend.',
              style: TextStyle(color: AppTheme.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.navy, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white24, size: 100),
                  if (_isScanning)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(color: AppTheme.gold, backgroundColor: Colors.transparent),
                    )
                  else
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text('Area Kamera', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Simulasi Hasil Scan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navy)),
                  const SizedBox(height: 8),
                  const Text('Tekan tombol untuk menampilkan informasi buku dummy dari QR Code.', style: TextStyle(color: AppTheme.muted, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _simulateScan,
                      child: Text(_isScanning ? 'Memindai...' : (_showResult ? 'Scan Ulang' : 'Mulai Scan')),
                    ),
                  ),
                  if (_showResult) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.gold, width: 1),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Berhasil', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('Mobile Computing Essentials', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Penulis: Sinta Maharani', style: TextStyle(fontSize: 12)),
                          Text('Kategori: Mobile Computing', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
