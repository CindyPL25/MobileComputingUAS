import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class AdminBorrowingsScreen extends ConsumerStatefulWidget {
  const AdminBorrowingsScreen({super.key});

  @override
  ConsumerState<AdminBorrowingsScreen> createState() => _AdminBorrowingsScreenState();
}

class _AdminBorrowingsScreenState extends ConsumerState<AdminBorrowingsScreen> {
  String _filterStatus = 'Semua';
  String _searchQuery = '';

  static const _statusOptions = ['Semua', 'Dipinjam', 'Dikembalikan', 'Terlambat'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminBorrowingsProvider);

    return LibraryAdminPage(
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString(), style: const TextStyle(color: AppTheme.red), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => ref.invalidate(adminBorrowingsProvider), child: const Text('Coba Lagi')),
            ],
          ),
        ),
        data: (all) {
          // Statistik ringkasan
          final active    = all.where((b) => b.status == 'Dipinjam').length;
          final returned  = all.where((b) => b.status == 'Dikembalikan').length;
          final overdue   = all.where((b) => b.status == 'Terlambat').length;
          final totalFine = all.fold<double>(0, (sum, b) => sum + b.fineAmount);

          // Filter
          var filtered = all.where((b) {
            final matchStatus = _filterStatus == 'Semua' || b.status == _filterStatus;
            final q = _searchQuery.toLowerCase();
            final matchSearch = q.isEmpty ||
                b.userName.toLowerCase().contains(q) ||
                b.userNim.toLowerCase().contains(q) ||
                b.bookTitles.toLowerCase().contains(q);
            return matchStatus && matchSearch;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminBorrowingsProvider),
            child: ListView(
              children: [
                LibraryContent(
                  maxWidth: 1100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──────────────────────────────────────────
                      const LibrarySurfaceCard(
                        child: LibrarySectionHeader(
                          eyebrow: 'Peminjaman',
                          title: 'Monitoring Peminjaman',
                          subtitle: 'Pantau status pinjam, jatuh tempo, dan denda seluruh mahasiswa.',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Stat Cards ───────────────────────────────────────
                      LibraryResponsiveGrid(
                        minTileWidth: 200,
                        children: [
                          LibraryStatCard(label: 'Total Transaksi', value: all.length.toString(), icon: Icons.receipt_long, color: AppTheme.navy),
                          LibraryStatCard(label: 'Aktif', value: active.toString(), icon: Icons.book_online, color: AppTheme.gold),
                          LibraryStatCard(label: 'Dikembalikan', value: returned.toString(), icon: Icons.check_circle_outline, color: AppTheme.green),
                          LibraryStatCard(label: 'Terlambat', value: overdue.toString(), icon: Icons.warning_amber_outlined, color: AppTheme.red),
                          LibraryStatCard(
                            label: 'Total Denda',
                            value: 'Rp${_formatRupiah(totalFine)}',
                            icon: Icons.attach_money,
                            color: AppTheme.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Filter & Search ─────────────────────────────────
                      LibrarySurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: const InputDecoration(
                                hintText: 'Cari nama mahasiswa, NIM, atau judul buku...',
                                prefixIcon: Icon(Icons.search, color: AppTheme.muted),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _statusOptions.map((s) {
                                  final selected = _filterStatus == s;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(s),
                                      selected: selected,
                                      onSelected: (_) => setState(() => _filterStatus = s),
                                      selectedColor: AppTheme.navy,
                                      labelStyle: TextStyle(
                                        color: selected ? Colors.white : AppTheme.navy,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── List ─────────────────────────────────────────────
                      if (filtered.isEmpty)
                        const LibrarySurfaceCard(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text('Tidak ada data peminjaman.', style: TextStyle(color: AppTheme.muted)),
                            ),
                          ),
                        )
                      else
                        ...filtered.map((b) => _BorrowingTile(item: b)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatRupiah(double amount) {
    final str = amount.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class _BorrowingTile extends StatelessWidget {
  const _BorrowingTile({required this.item});
  final AdminBorrowingModel item;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.status) {
      'Dikembalikan' => AppTheme.green,
      'Terlambat'    => AppTheme.red,
      _              => AppTheme.gold,
    };

    final hasFine = item.fineAmount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
        boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: nama + status
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    item.userName.isNotEmpty ? item.userName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy, fontSize: 14)),
                    Text('NIM: ${item.userNim}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(item.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.line, height: 1),
          const SizedBox(height: 12),

          // Judul buku
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.menu_book, size: 16, color: AppTheme.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.bookTitles.isEmpty ? '-' : item.bookTitles,
                  style: const TextStyle(fontSize: 13, color: AppTheme.ink, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tanggal
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _InfoChip(Icons.calendar_today, 'Pinjam', item.borrowDate),
              _InfoChip(Icons.event, 'Jatuh Tempo', item.dueDate),
              _InfoChip(
                Icons.assignment_return,
                'Kembali',
                item.returnDate.isEmpty ? 'Belum' : item.returnDate,
                color: item.returnDate.isEmpty ? AppTheme.gold : AppTheme.green,
              ),
              if (hasFine)
                _InfoChip(Icons.attach_money, 'Denda', 'Rp${item.fineAmount.toInt()}', color: AppTheme.red),
            ],
          ),
          if (item.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Catatan: ${item.notes}', style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label, this.value, {this.color = AppTheme.muted});
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text('$label: ', style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
