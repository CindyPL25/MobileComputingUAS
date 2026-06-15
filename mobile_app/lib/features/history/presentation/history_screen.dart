import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(borrowingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LibraryContent(
            child: LibrarySurfaceCard(
              child: LibrarySectionHeader(
                eyebrow: 'Riwayat',
                title: 'Peminjaman buku',
                subtitle: 'Pantau daftar peminjaman dan pengembalian buku.',
              ),
            ),
          ),
          Expanded(
            child: historyState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(error.toString(), style: const TextStyle(color: AppTheme.red), textAlign: TextAlign.center),
                ),
              ),
              data: (history) {
                if (history.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat peminjaman.', style: TextStyle(color: AppTheme.muted)));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(borrowingsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) => Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _HistoryCard(item: history[index]),
                      ),
                    ),
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

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
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
          _buildInfo(Icons.file_upload_outlined, 'Pinjam: ${item.borrowedAt}'),
          const SizedBox(height: 6),
          _buildInfo(Icons.event_available_outlined, 'Jatuh tempo: ${item.dueDate}'),
          const SizedBox(height: 6),
          _buildInfo(Icons.file_download_outlined, 'Kembali: ${item.returnedAt.isEmpty ? 'Belum dikembalikan' : item.returnedAt}'),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.muted),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(color: AppTheme.muted, fontSize: 12))),
      ],
    );
  }
}
