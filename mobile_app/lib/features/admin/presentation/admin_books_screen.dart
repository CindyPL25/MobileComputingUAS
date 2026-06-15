import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class AdminBooksScreen extends ConsumerStatefulWidget {
  const AdminBooksScreen({super.key});

  @override
  ConsumerState<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends ConsumerState<AdminBooksScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Umum');
  final _bookCodeController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  final _coverController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _bookCodeController.dispose();
    _stockController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(apiRepositoryProvider).createBook(
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            category: _categoryController.text.trim(),
            bookCode: _bookCodeController.text.trim(),
            stock: int.tryParse(_stockController.text.trim()) ?? 1,
            coverImage: _coverController.text.trim(),
          );
      ref
        ..invalidate(booksProvider)
        ..invalidate(dashboardProvider);
      _titleController.clear();
      _authorController.clear();
      _categoryController.text = 'Umum';
      _bookCodeController.clear();
      _stockController.text = '1';
      _coverController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buku berhasil ditambahkan.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return LibraryAdminPage(
      child: booksState.when(
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
                        title: 'Koleksi Buku',
                        subtitle: 'Tambah koleksi baru dan pantau data buku.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BookForm(
                      formKey: _formKey,
                      titleController: _titleController,
                      authorController: _authorController,
                      categoryController: _categoryController,
                      bookCodeController: _bookCodeController,
                      stockController: _stockController,
                      coverController: _coverController,
                      isSaving: _isSaving,
                      onSave: _saveBook,
                    ),
                    const SizedBox(height: 16),
                    Text('${books.length} koleksi', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                    const SizedBox(height: 12),
                    if (books.isEmpty)
                      const LibrarySurfaceCard(child: Text('Belum ada koleksi buku dari backend.', style: TextStyle(color: AppTheme.muted)))
                    else
                      LibraryResponsiveGrid(
                        minTileWidth: 430,
                        children: books.map((book) => _BookTile(
                          book: book,
                          onEdit: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur edit akan segera hadir.')));
                          },
                          onDelete: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur hapus akan segera hadir.')));
                          },
                        )).toList(),
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

class _BookForm extends StatelessWidget {
  const _BookForm({
    required this.formKey,
    required this.titleController,
    required this.authorController,
    required this.categoryController,
    required this.bookCodeController,
    required this.stockController,
    required this.coverController,
    required this.isSaving,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController categoryController;
  final TextEditingController bookCodeController;
  final TextEditingController stockController;
  final TextEditingController coverController;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return LibrarySurfaceCard(
      child: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final fields = [
              _field(titleController, 'Judul Buku', required: true),
              _field(authorController, 'Penulis', required: true),
              _field(categoryController, 'Kategori', required: true),
              _field(bookCodeController, 'Kode Buku / QR', hint: 'BK001'),
              _field(stockController, 'Stok', keyboardType: TextInputType.number, required: true),
              _field(coverController, 'Cover Image', hint: 'images/books/nama-file.png'),
            ];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Input buku admin', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 12),
                if (isWide)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: fields.map((field) => SizedBox(width: (constraints.maxWidth - 12) / 2, child: field)).toList(),
                  )
                else
                  Column(children: fields.map((field) => Padding(padding: const EdgeInsets.only(bottom: 12), child: field)).toList()),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : onSave,
                    child: Text(isSaving ? 'Menyimpan...' : 'Simpan Buku'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? hint,
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: required
          ? (value) {
              if ((value ?? '').trim().isEmpty) return '$label wajib diisi';
              if (label == 'Stok' && (int.tryParse((value ?? '').trim()) ?? -1) < 0) return 'Stok tidak valid';
              return null;
            }
          : null,
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
            width: 94,
            height: 136,
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 7))],
            ),
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
