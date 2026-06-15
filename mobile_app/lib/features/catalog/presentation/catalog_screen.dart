import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: booksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: error.toString(), onRetry: () => ref.invalidate(booksProvider)),
        data: (allBooks) {
          final categories = ['Semua', ...allBooks.map((book) => book.category).where((category) => category.isNotEmpty).toSet().toList()..sort()];
          final filteredBooks = allBooks.where((book) {
            final query = _searchQuery.toLowerCase();
            final matchesSearch = book.title.toLowerCase().contains(query) || book.author.toLowerCase().contains(query);
            final matchesCategory = _selectedCategory == 'Semua' || book.category == _selectedCategory;
            return matchesSearch && matchesCategory;
          }).toList();

          return Column(
            children: [
              LibraryContent(
                child: LibrarySurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LibrarySectionHeader(
                        eyebrow: 'Katalog Digital',
                        title: 'Temukan buku kampus',
                        subtitle: 'Cari koleksi, cek stok, lalu buka detail buku langsung dari backend.',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Cari judul atau penulis...',
                          prefixIcon: Icon(Icons.search, color: AppTheme.muted),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.line),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: categories.contains(_selectedCategory) ? _selectedCategory : 'Semua',
                            items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: filteredBooks.isEmpty
                    ? const Center(child: Text('Tidak ada buku yang cocok dengan pencarian.', style: TextStyle(color: AppTheme.muted)))
                    : RefreshIndicator(
                        onRefresh: () async => ref.invalidate(booksProvider),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.sizeOf(context).width > 760 ? 520 : 900,
                            mainAxisExtent: MediaQuery.sizeOf(context).width > 520 ? 198 : 204,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                          ),
                          itemCount: filteredBooks.length,
                        itemBuilder: (context, index) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: _buildBookCard(context, filteredBooks[index]),
                            ),
                          ),
                        ),
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BookModel book) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverImage(book.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(4)),
                          child: Text(book.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.gold), overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(book.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: book.availableStock > 0 ? AppTheme.green : AppTheme.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(book.author, style: const TextStyle(fontSize: 12, color: AppTheme.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('Stok ${book.availableStock}/${book.stock}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 160,
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.12), blurRadius: 14, offset: const Offset(0, 8))],
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? const Icon(Icons.menu_book, color: Colors.black26)
          : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: Colors.black26)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: AppTheme.red), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
