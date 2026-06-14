import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminBorrowingsScreen extends ConsumerWidget {
  const AdminBorrowingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(borrowingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Peminjaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: historyState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (history) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(borrowingsProvider),
          child: ListView(
            children: [
              LibraryContent(
                maxWidth: 900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LibrarySurfaceCard(
                      child: LibrarySectionHeader(
                        eyebrow: 'Peminjaman',
                        title: 'Riwayat dari API',
                        subtitle: 'Endpoint mobile mengembalikan riwayat untuk user token aktif.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (history.isEmpty)
                      const LibrarySurfaceCard(child: Text('Belum ada data peminjaman.', style: TextStyle(color: AppTheme.muted)))
                    else
                      ...history.map(_BorrowingTile.new),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BorrowingTile extends StatelessWidget {
  const _BorrowingTile(this.item);

  final HistoryModel item;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.status.toLowerCase()) {
      'dikembalikan' => AppTheme.green,
      'terlambat' => AppTheme.red,
      _ => AppTheme.gold,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text('Pinjam: ${item.borrowedAt}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          Text('Jatuh tempo: ${item.dueDate}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          Text('Kembali: ${item.returnedAt.isEmpty ? 'Belum dikembalikan' : item.returnedAt}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor),
            ),
            child: Text(item.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
