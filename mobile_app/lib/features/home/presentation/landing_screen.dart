import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navySoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PERPUSTAKAAN DIGITAL KAMPUS',
                style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),
              const Text(
                'Mobile E-Library\nKampus',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, height: 1.1),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sistem perpustakaan mobile web untuk mencari katalog buku, melihat detail koleksi, dan melakukan simulasi scan QR Code buku dengan cepat.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    side: const BorderSide(color: Colors.white24),
                  ),
                  child: const Text('Mulai Baca (Login)'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/catalog'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.navy,
                  ),
                  child: const Text('Lihat Katalog Dummy'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/admin-login'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                  ),
                  child: const Text('Masuk Sebagai Admin', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fitur Utama', style: TextStyle(color: AppTheme.navy, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildFeature(Icons.library_books, 'Katalog Buku Digital'),
                    _buildFeature(Icons.qr_code_scanner, 'Scan QR Code Buku'),
                    _buildFeature(Icons.history, 'Riwayat Peminjaman'),
                    _buildFeature(Icons.phone_android, 'Akses Mobile Friendly'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.gold),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.ink)),
        ],
      ),
    );
  }
}
