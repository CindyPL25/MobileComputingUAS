import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';
import 'widgets/admin_drawer.dart';

class AdminQrScreen extends ConsumerWidget {
  const AdminQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrScans = ref.watch(qrScansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('QR CODE', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Log scan dan QR buku', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.navy)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.navy, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.qr_code_2, size: 100, color: AppTheme.navy),
                  ),
                  const SizedBox(height: 16),
                  const Text('QR koleksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navy)),
                  const SizedBox(height: 8),
                  const Text('QR ini masih placeholder. Nantinya setiap buku bisa punya kode unik dari database.', style: TextStyle(fontSize: 12, color: AppTheme.muted), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () {}, child: const Text('Generate Dummy')),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Riwayat scan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navy)),
                Text('${qrScans.length} log', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            ...qrScans.map((scan) =>
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scan.book, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(scan.student, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                              Text('${scan.location} · ${scan.time}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.green),
                          ),
                          child: const Text('Berhasil', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, fontSize: 10)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
