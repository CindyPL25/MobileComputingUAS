import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminBooksScreen extends ConsumerStatefulWidget {
  const AdminBooksScreen({super.key});

  @override
  ConsumerState<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends ConsumerState<AdminBooksScreen> {
  Future<void> _showBookForm([BookModel? book]) async {
    final isEditing = book != null;
    final titleCtrl = TextEditingController(text: book?.title);
    final authorCtrl = TextEditingController(text: book?.author);
    final publisherCtrl = TextEditingController(text: book?.publisher);
    final yearCtrl = TextEditingController(text: book?.year.toString());
    final stockCtrl = TextEditingController(text: book?.stock.toString());
    final descCtrl = TextEditingController(text: book?.description);

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Buku' : 'Tambah Buku'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: authorCtrl,
                  decoration: const InputDecoration(labelText: 'Penulis'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: publisherCtrl,
                  decoration: const InputDecoration(labelText: 'Penerbit'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: yearCtrl,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                try {
                  final data = {
                    'title': titleCtrl.text,
                    'author': authorCtrl.text,
                    'publisher': publisherCtrl.text,
                    'publication_year': yearCtrl.text,
                    'stock': int.tryParse(stockCtrl.text) ?? 0,
                    'description': descCtrl.text,
                  };

                  if (isEditing) {
                    data['id'] = book.id;
                    await ref.read(apiRepositoryProvider).updateBook(data);
                  } else {
                    await ref.read(apiRepositoryProvider).addBook(data);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Buku diperbarui' : 'Buku ditambahkan')));
                    ref.invalidate(booksProvider);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.red));
                  }
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBook(BookModel book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: Text('Yakin ingin menghapus ${book.title}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(apiRepositoryProvider).deleteBook(book.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buku dihapus')));
          ref.invalidate(booksProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBookForm,
        backgroundColor: AppTheme.navy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                        subtitle: 'Kelola buku langsung dari aplikasi admin.',
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
                        children: books.map((book) => _BookTile(book: book, onEdit: () => _showBookForm(book), onDelete: () => _deleteBook(book))).toList(),
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
  const _BookTile({required this.book, required this.onEdit, required this.onDelete});

  final BookModel book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16, color: AppTheme.red),
                      label: const Text('Hapus', style: TextStyle(fontSize: 12, color: AppTheme.red)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
