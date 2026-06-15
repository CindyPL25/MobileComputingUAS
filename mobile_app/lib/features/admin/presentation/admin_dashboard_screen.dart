import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final historyState = ref.watch(borrowingsProvider);

    return LibraryAdminPage(
      child: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (stats) {
          final histories = historyState.valueOrNull ?? <HistoryModel>[];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LibraryHeroPanel(
                  compact: true,
                  eyebrow: 'Panel Admin',
                  title: 'Ringkasan backend',
                  subtitle: 'Kelola koleksi, pantau peminjaman, dan siapkan kode QR buku dari database yang sama dengan website PHP Native.',
                  imagePath: 'images/home-library-service.png',
                  actions: [
                    ElevatedButton(onPressed: () => context.push('/admin-books'), child: const Text('Data Buku')),
                    OutlinedButton(onPressed: () => context.push('/admin-borrowings'), child: const Text('Peminjaman')),
                    OutlinedButton(onPressed: () => context.push('/admin-qr'), child: const Text('Kode QR')),
                  ],
                ),
                LibraryContent(
                  child: Column(
                    children: [
                      LibrarySectionHeader(
                        eyebrow: 'Kontrol Admin',
                        title: 'Kelola operasional perpustakaan',
                        subtitle: 'Pantau statistik utama, tambah koleksi, cek peminjaman, dan akses pengaturan QR dari satu portal admin.',
                        action: TextButton.icon(
                          onPressed: () => context.push('/admin-profile'),
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Profil'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LibraryResponsiveGrid(
                        minTileWidth: 210,
                        children: [
                          LibraryStatCard(label: 'Total Buku', value: stats.totalBooks.toString(), icon: Icons.library_books, color: AppTheme.navy),
                          LibraryStatCard(label: 'Mahasiswa', value: stats.totalUsers.toString(), icon: Icons.people, color: AppTheme.gold),
                          LibraryStatCard(label: 'Dipinjam', value: stats.totalActiveBorrowings.toString(), icon: Icons.book_online, color: AppTheme.green),
                          LibraryStatCard(label: 'Kategori', value: stats.totalCategories.toString(), icon: Icons.category, color: AppTheme.muted),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const LibrarySectionHeader(
                        eyebrow: 'Peminjaman Akun Ini',
                        title: 'Monitoring singkat',
                        subtitle: 'Endpoint API mobile saat ini mengembalikan peminjaman milik token aktif.',
                      ),
                      const SizedBox(height: 12),
                      if (histories.isEmpty)
                        const LibrarySurfaceCard(child: Text('Belum ada data peminjaman.', style: TextStyle(color: AppTheme.muted)))
                      else
                        ...histories.take(3).map(_HistoryTile.new),
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
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile(this.item);

  final HistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.line)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.navy), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${item.borrowedAt} - ${item.returnedAt.isEmpty ? item.dueDate : item.returnedAt}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          ),
          Text(item.status, style: const TextStyle(fontSize: 10, color: AppTheme.green, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
