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

    return LibraryAdminPage(
      child: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (stats) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LibraryHeroPanel(
                  compact: true,
                  eyebrow: 'Panel Admin',
                  title: 'Admin',
                  subtitle: 'Kelola koleksi, pantau peminjaman, dan siapkan kode QR buku.',
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

