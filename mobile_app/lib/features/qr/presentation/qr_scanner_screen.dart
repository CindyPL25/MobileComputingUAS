import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

enum QrAction { validate, borrow, returnBook }

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key, this.initialBookCode});

  final String? initialBookCode;

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final _manualCodeController = TextEditingController();
  final _scannerController = MobileScannerController();
  QrAction _action = QrAction.validate;
  bool _isProcessing = false;
  String? _lastScannedCode;
  QrActionResult? _result;

  @override
  void initState() {
    super.initState();
    final initialCode = widget.initialBookCode;
    if (initialCode != null && initialCode.isNotEmpty) {
      _manualCodeController.text = initialCode;
      _lastScannedCode = initialCode;
    }
  }

  @override
  void dispose() {
    _manualCodeController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    String? code;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        code = value;
        break;
      }
    }
    if (code == null) return;
    await _processCode(code);
  }

  Future<void> _processManualCode() async {
    final code = _manualCodeController.text.trim();
    if (code.isEmpty) {
      _showSnack('Kode QR belum diisi.');
      return;
    }
    await _processCode(code);
  }

  Future<void> _processCode(String code) async {
    setState(() {
      _isProcessing = true;
      _lastScannedCode = code;
      _manualCodeController.text = code;
      _result = null;
    });

    try {
      final repository = ref.read(apiRepositoryProvider);
      final result = switch (_action) {
        QrAction.validate => await repository.validateBookCode(code),
        QrAction.borrow => await repository.borrowByQr(code),
        QrAction.returnBook => await repository.returnByQr(code),
      };
      ref
        ..invalidate(booksProvider)
        ..invalidate(borrowingsProvider)
        ..invalidate(dashboardProvider)
        ..invalidate(notificationsProvider);
      if (mounted) {
        setState(() => _result = result);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _result = QrActionResult(
            success: false,
            message: error.toString().replaceFirst('Exception: ', ''),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: LibraryContent(
          maxWidth: 1040,
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 820;
              final scannerPanel = LibrarySurfaceCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LibrarySectionHeader(
                      eyebrow: 'Scanner',
                      title: 'Scan kode buku',
                      subtitle: 'Arahkan kamera ke QR Code buku. Hasil scan dikirim untuk validasi, peminjaman, atau pengembalian.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: isWide ? 360 : 280,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.navy, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: _scannerController,
                            onDetect: _handleDetect,
                          ),
                          if (_isProcessing)
                            const Align(
                              alignment: Alignment.topCenter,
                              child: LinearProgressIndicator(color: AppTheme.gold, backgroundColor: Colors.transparent),
                            ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              color: Colors.black54,
                              child: Text(
                                _lastScannedCode == null ? 'Kamera aktif - menunggu QR' : 'Kode: $_lastScannedCode',
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              final actionPanel = LibrarySurfaceCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('QR Scanner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navy)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<QrAction>(
                      initialValue: _action,
                      decoration: const InputDecoration(labelText: 'Aksi'),
                      items: const [
                        DropdownMenuItem(value: QrAction.validate, child: Text('Validasi QR')),
                        DropdownMenuItem(value: QrAction.borrow, child: Text('Pinjam via QR')),
                        DropdownMenuItem(value: QrAction.returnBook, child: Text('Kembalikan via QR')),
                      ],
                      onChanged: _isProcessing
                          ? null
                          : (value) {
                              if (value != null) setState(() => _action = value);
                            },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Kode QR / Book Code',
                        hintText: 'TECH001',
                        prefixIcon: Icon(Icons.qr_code_2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processManualCode,
                        child: Text(_isProcessing ? 'Memproses...' : 'Kirim'),
                      ),
                    ),
                    if (_result != null) ...[
                      const SizedBox(height: 20),
                      _ResultPanel(result: _result!),
                    ],
                  ],
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: scannerPanel),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: actionPanel),
                  ],
                );
              }

              return Column(
                children: [
                  scannerPanel,
                  const SizedBox(height: 16),
                  actionPanel,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.result});

  final QrActionResult result;

  @override
  Widget build(BuildContext context) {
    final color = result.success ? AppTheme.green : AppTheme.red;
    final book = result.book;
    final borrowing = result.borrowing;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.success ? 'Berhasil' : 'Gagal', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          Text(result.message, style: const TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w600)),
          if (book != null) ...[
            const SizedBox(height: 8),
            Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Penulis: ${book.author}', style: const TextStyle(fontSize: 12)),
            Text('Stok: ${book.availableStock}/${book.stock}', style: const TextStyle(fontSize: 12)),
          ],
          if (borrowing != null) ...[
            const SizedBox(height: 8),
            Text('Transaksi #${borrowing.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Status: ${borrowing.status}', style: const TextStyle(fontSize: 12)),
            Text('Batas kembali: ${borrowing.dueDate}', style: const TextStyle(fontSize: 12)),
          ],
        ],
      ),
    );
  }
}
