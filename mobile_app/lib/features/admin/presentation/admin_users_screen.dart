import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return LibraryAdminPage(
      child: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (dashboard) => SingleChildScrollView(
          child: LibraryContent(
            maxWidth: 1040,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LibrarySectionHeader(
                  eyebrow: 'Portal Pengguna',
                  title: 'Informasi akun mahasiswa dan admin',
                  subtitle: 'Ringkasan akses pengguna.',
                ),
                const SizedBox(height: 18),
                LibraryResponsiveGrid(
                  minTileWidth: 220,
                  children: [
                    LibraryStatCard(label: 'Total Pengguna', value: dashboard.totalUsers.toString(), icon: Icons.people_alt_outlined, color: AppTheme.navy),
                    const LibraryStatCard(label: 'Role Aktif', value: '2', icon: Icons.verified_user_outlined, color: AppTheme.gold),
                    const LibraryStatCard(label: 'Sumber Data', value: 'MySQL', icon: Icons.storage_outlined, color: AppTheme.green),
                  ],
                ),
                const SizedBox(height: 18),
                LibraryResponsiveGrid(
                  minTileWidth: 300,
                  children: const [
                    _UserInfoCard(
                      icon: Icons.school_outlined,
                      title: 'Mahasiswa',
                      text: 'Akun mahasiswa dipakai untuk login aplikasi, melihat katalog, riwayat peminjaman, notifikasi, dan proses QR.',
                    ),
                    _UserInfoCard(
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'Admin',
                      text: 'Akun admin dipakai untuk mengelola koleksi, memantau peminjaman, mengakses kode QR, dan melihat ringkasan backend.',
                    ),
                    _UserInfoCard(
                      icon: Icons.lock_outline,
                      title: 'Validasi Role',
                      text: 'Login mahasiswa dan admin sudah dipisah. Akun admin tidak bisa masuk lewat halaman mahasiswa, begitu juga sebaliknya.',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const LibrarySurfaceCard(
                  width: double.infinity,
                  padding: EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catatan pengelolaan', style: TextStyle(color: AppTheme.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                      SizedBox(height: 8),
                      Text(
                        'Portal Flutter menampilkan ringkasan pengguna dari API dashboard. Untuk CRUD user lengkap, gunakan website admin PHP Native karena endpoint mobile user-list belum tersedia.',
                        style: TextStyle(color: AppTheme.muted, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LibrarySurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppTheme.creamStrong, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.navy),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(color: AppTheme.navy, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.42)),
        ],
      ),
    );
  }
}
