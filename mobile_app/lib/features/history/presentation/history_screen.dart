import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/dummy_data_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppTheme.surface,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RIWAYAT', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Peminjaman buku', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navy)),
                SizedBox(height: 8),
                Text('Pantau daftar peminjaman dan pengembalian buku dalam tampilan yang nyaman di mobile.', style: TextStyle(color: AppTheme.muted)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                
                Color statusColor;
                if (item.status.toLowerCase() == 'dikembalikan') {
                  statusColor = AppTheme.green;
                } else if (item.status.toLowerCase() == 'terlambat') {
                  statusColor = AppTheme.red;
                } else {
                  statusColor = AppTheme.gold;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.navy, height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(item.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppTheme.line),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.file_upload_outlined, size: 16, color: AppTheme.muted),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Pinjam: ${item.borrowedAt}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.file_download_outlined, size: 16, color: AppTheme.muted),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Kembali: ${item.returnedAt}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
