import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/library_chrome.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LibraryBrandBar(showNav: true),
            LibraryHeroPanel(
              eyebrow: 'Perpustakaan Digital Kampus',
              title: 'Mobile E-Library\nKampus',
              subtitle:
                  'Sistem perpustakaan mobile untuk mencari katalog buku, melihat detail koleksi, memantau peminjaman, dan memproses QR Code dengan backend PHP Native.',
              imagePath: 'images/hero-library.png',
              actions: [
                ElevatedButton(onPressed: () => context.push('/login'), child: const Text('Mulai Baca')),
                ElevatedButton(
                  onPressed: () => context.push('/catalog'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.surface, foregroundColor: AppTheme.navy),
                  child: const Text('Lihat Katalog'),
                ),
                OutlinedButton(onPressed: () => context.push('/login'), child: const Text('Scan QR')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 42, 20, 42),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 760;
                          final intro = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LibrarySectionHeader(
                                eyebrow: 'Tentang Layanan',
                                title: 'Perpustakaan kampus yang lebih dekat dengan mahasiswa',
                                subtitle:
                                    'Mobile E-Library membantu mahasiswa mencari referensi, melihat stok koleksi, memantau peminjaman, dan memakai QR Code dari satu aplikasi yang terhubung ke backend PHP Native.',
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: const [
                                  _MiniStat(value: '6', label: 'Koleksi aktif'),
                                  _MiniStat(value: '4', label: 'Kategori buku'),
                                  _MiniStat(value: '100%', label: 'Data backend'),
                                ],
                              ),
                            ],
                          );
                          final image = ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              LibraryChrome.asset(context, 'images/home-library-service.png'),
                              fit: BoxFit.cover,
                              height: isWide ? 300 : 190,
                              width: double.infinity,
                            ),
                          );

                          if (!isWide) {
                            return Column(children: [intro, const SizedBox(height: 20), image]);
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: intro),
                              const SizedBox(width: 34),
                              Expanded(child: image),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 34),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth > 900;
                          final isPhone = constraints.maxWidth < 560;
                          return GridView.count(
                            crossAxisCount: isDesktop ? 4 : (isPhone ? 1 : 2),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: isDesktop ? 1.55 : (isPhone ? 2.25 : 1.15),
                            children: const [
                              _FeatureCard(icon: Icons.library_books, title: 'Katalog Buku', text: 'Cari koleksi dan cek stok buku dari MySQL.'),
                              _FeatureCard(icon: Icons.qr_code_scanner, title: 'Scan QR', text: 'Validasi kode buku untuk proses pinjam/kembali.'),
                              _FeatureCard(icon: Icons.history, title: 'Riwayat', text: 'Pantau status peminjaman dari akun mahasiswa.'),
                              _FeatureCard(icon: Icons.admin_panel_settings, title: 'Panel Admin', text: 'Monitor koleksi, pengguna, dan kode QR buku.'),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 34),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 820;
                          final cards = const [
                            _RoleCard(
                              icon: Icons.school,
                              title: 'Untuk Mahasiswa',
                              text: 'Login, buka katalog, lihat detail buku, pantau riwayat, baca notifikasi, dan gunakan QR dari menu scan.',
                            ),
                            _RoleCard(
                              icon: Icons.admin_panel_settings,
                              title: 'Untuk Admin',
                              text: 'Masuk ke panel pengelola, lihat ringkasan backend, cek koleksi buku, peminjaman, dan daftar kode QR.',
                            ),
                          ];

                          if (!isWide) {
                            return Column(
                              children: [
                                cards[0],
                                const SizedBox(height: 14),
                                cards[1],
                              ],
                            );
                          }

                          return const Row(
                            children: [
                              Expanded(child: _RoleCard(icon: Icons.school, title: 'Untuk Mahasiswa', text: 'Login, buka katalog, lihat detail buku, pantau riwayat, baca notifikasi, dan gunakan QR dari menu scan.')),
                              SizedBox(width: 14),
                              Expanded(child: _RoleCard(icon: Icons.admin_panel_settings, title: 'Untuk Admin', text: 'Masuk ke panel pengelola, lihat ringkasan backend, cek koleksi buku, peminjaman, dan daftar kode QR.')),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LibrarySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.gold),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: AppTheme.muted, fontSize: 12, height: 1.35)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: AppTheme.navy, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return LibrarySurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
