import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminBooksScreen extends ConsumerWidget {
  const AdminBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: booksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (books) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(booksProvider),
          child: ListView(
            children: [
              LibraryContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LibrarySurfaceCard(
                      child: LibrarySectionHeader(
                        eyebrow: 'Data Buku',
                        title: 'Koleksi dari backend',
                        subtitle: 'API mobile yang tersedia membaca data buku dari database.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('${books.length} koleksi', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                    const SizedBox(height: 12),
                    if (books.isEmpty)
                      const LibrarySurfaceCard(child: Text('Belum ada koleksi buku dari backend.', style: TextStyle(color: AppTheme.muted)))
                    else
                      LibraryResponsiveGrid(
                        minTileWidth: 360,
                        children: books.map(_BookTile.new).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile(this.book);

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.line)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(4)),
            clipBehavior: Clip.antiAlias,
            child: book.cover.isEmpty
                ? const Icon(Icons.menu_book, color: Colors.black26, size: 24)
                : Image.network(book.cover, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: Colors.black26, size: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(book.author, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                const SizedBox(height: 4),
                Text('${book.publisher} (${book.year})', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                const SizedBox(height: 4),
                Text('Kode: ${book.bookCode} - Stok ${book.availableStock}/${book.stock}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
