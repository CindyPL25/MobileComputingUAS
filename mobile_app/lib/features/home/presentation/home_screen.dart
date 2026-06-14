import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final history = ref.watch(historyProvider);
    
    final borrowedCount = history.where((i) => i.status == 'Dipinjam').length;
    final returnedCount = history.where((i) => i.status == 'Dikembalikan').length;
    final popularBooks = books.where((b) => b.popular).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile E-Library', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () => context.go('/landing'), icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DASHBOARD MAHASISWA', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Halo, Cindy Maharani', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navy)),
                  const SizedBox(height: 8),
                  const Text('Temukan buku kuliah, pantau peminjaman, dan scan QR buku langsung dari perangkat mobile.', style: TextStyle(color: AppTheme.muted)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton(onPressed: () => context.go('/catalog'), child: const Text('Buka Katalog'))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: AppTheme.navy, side: const BorderSide(color: AppTheme.line)),
                          onPressed: () => context.go('/qr'), 
                          child: const Text('Scan QR')
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Buku', books.length.toString(), Icons.library_books, AppTheme.navy)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Dipinjam', borrowedCount.toString(), Icons.book_online, AppTheme.gold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Dikembalikan', returnedCount.toString(), Icons.check_circle_outline, AppTheme.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('QR Scan', '18', Icons.qr_code, AppTheme.muted)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REKOMENDASI', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Buku populer minggu ini', style: TextStyle(color: AppTheme.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                  ],
                ),
                TextButton(onPressed: () => context.go('/catalog'), child: const Text('Lihat semua'))
              ],
            ),
            const SizedBox(height: 12),
            ...popularBooks.map((book) => _buildBookCard(context, book)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navy)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, dynamic book) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(image: NetworkImage(book.cover), fit: BoxFit.cover, onError: (e, s) {}),
              ),
              child: const Icon(Icons.image_not_supported, color: Colors.black12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(4)),
                    child: Text(book.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.gold)),
                  ),
                  const SizedBox(height: 8),
                  Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(book.author, style: const TextStyle(fontSize: 12, color: AppTheme.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

