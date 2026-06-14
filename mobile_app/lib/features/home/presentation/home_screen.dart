import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final profile = ref.watch(profileProvider);
    final books = ref.watch(booksProvider);
    final history = ref.watch(borrowingsProvider);

    return Scaffold(
      body: Column(
        children: [
          LibraryBrandBar(
            trailing: IconButton(
              onPressed: () => context.push('/notifications'),
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            onLogout: () async {
              await ref.read(authControllerProvider.notifier).logout();
              ref
                ..invalidate(profileProvider)
                ..invalidate(dashboardProvider)
                ..invalidate(booksProvider)
                ..invalidate(borrowingsProvider)
                ..invalidate(notificationsProvider);
              if (context.mounted) context.go('/landing');
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref
                  ..invalidate(profileProvider)
                  ..invalidate(dashboardProvider)
                  ..invalidate(booksProvider)
                  ..invalidate(borrowingsProvider)
                  ..invalidate(notificationsProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: dashboard.when(
                  loading: () => const _LoadingBlock(),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: _ErrorBlock(message: error.toString()),
                  ),
                  data: (stats) {
                    final user = profile.valueOrNull;
                    final bookList = books.valueOrNull ?? <BookModel>[];
                    final histories = history.valueOrNull ?? <HistoryModel>[];
                    final returnedCount = histories.where((item) => item.status == 'Dikembalikan').length;
                    final popularBooks = bookList.where((book) => book.popular).take(3).toList();
                    final recommendedBooks = popularBooks.isEmpty ? bookList.take(3).toList() : popularBooks;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LibraryHeroPanel(
                          compact: true,
                          eyebrow: 'Dashboard Mahasiswa',
                          title: 'Halo, ${user?.name ?? 'Pengguna'}',
                          subtitle: 'Temukan buku kuliah, pantau peminjaman, dan scan QR buku langsung dari perangkat mobile.',
                          imagePath: 'images/home-reading-area.png',
                          actions: [
                            ElevatedButton(onPressed: () => context.go('/catalog'), child: const Text('Buka Katalog')),
                            OutlinedButton(onPressed: () => context.go('/qr'), child: const Text('Scan QR')),
                          ],
                        ),
                        LibraryContent(
                          child: Column(
                            children: [
                              LibraryResponsiveGrid(
                                minTileWidth: 210,
                                children: [
                                  LibraryStatCard(label: 'Total Buku', value: stats.totalBooks.toString(), icon: Icons.library_books, color: AppTheme.navy),
                                  LibraryStatCard(label: 'Dipinjam', value: stats.totalActiveBorrowings.toString(), icon: Icons.book_online, color: AppTheme.gold),
                                  LibraryStatCard(label: 'Dikembalikan', value: returnedCount.toString(), icon: Icons.check_circle_outline, color: AppTheme.green),
                                  LibraryStatCard(label: 'Kategori', value: stats.totalCategories.toString(), icon: Icons.category_outlined, color: AppTheme.muted),
                                ],
                              ),
                              const SizedBox(height: 24),
                              LibrarySectionHeader(
                                eyebrow: 'Rekomendasi',
                                title: 'Buku dari database',
                                action: TextButton(onPressed: () => context.go('/catalog'), child: const Text('Lihat semua')),
                              ),
                              const SizedBox(height: 12),
                              LibraryResponsiveGrid(
                                minTileWidth: 320,
                                children: recommendedBooks.map((book) => _buildBookCard(context, book)).toList(),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BookModel book) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookCover(book.cover, width: 80, height: 110),
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

class _BookCover extends StatelessWidget {
  const _BookCover(this.url, {required this.width, required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(6)),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? const Icon(Icons.menu_book, color: Colors.black26)
          : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: Colors.black26)),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.line)),
      child: Text(message, style: const TextStyle(color: AppTheme.red)),
    );
  }
}
