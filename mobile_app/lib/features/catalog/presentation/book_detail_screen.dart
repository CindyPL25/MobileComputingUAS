import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class BookDetailScreen extends ConsumerWidget {
  final int bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookState = ref.watch(bookDetailProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Koleksi', style: TextStyle(fontSize: 16)),
      ),
      body: bookState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(error.toString(), style: const TextStyle(color: AppTheme.red), textAlign: TextAlign.center),
          ),
        ),
        data: (book) => _BookDetailContent(book: book),
      ),
    );
  }
}

class _BookDetailContent extends StatelessWidget {
  const _BookDetailContent({required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LibraryContent(
        maxWidth: 980,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            final cover = Center(
              child: Container(
                width: wide ? 240 : 160,
                height: wide ? 330 : 220,
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                clipBehavior: Clip.antiAlias,
                child: book.cover.isEmpty
                    ? const Icon(Icons.menu_book, color: Colors.black26, size: 48)
                    : Image.network(book.cover, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: Colors.black26, size: 48)),
              ),
            );
            final details = LibrarySurfaceCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(99)),
                    child: Text(book.category, style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navy, height: 1.2)),
                  const SizedBox(height: 12),
                  Text(book.description.isEmpty ? '-' : book.description, style: const TextStyle(color: AppTheme.muted, fontSize: 14, height: 1.45)),
                  const SizedBox(height: 20),
                  const Divider(color: AppTheme.line),
                  const SizedBox(height: 12),
                  _buildMetaRow('Penulis', book.author),
                  _buildMetaRow('Tahun', book.year),
                  _buildMetaRow('Penerbit', book.publisher),
                  _buildMetaRow('ISBN', book.isbn),
                  _buildMetaRow('Stok', '${book.availableStock}/${book.stock}'),
                  _buildMetaRow('Status', book.status, isStatus: true),
                  _buildMetaRow('Kode QR', book.bookCode),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.line),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code_2, size: 40, color: AppTheme.navy),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('QR Code Koleksi', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy)),
                              Text(book.bookCode.isEmpty ? 'Kode QR belum tersedia.' : book.bookCode, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: book.bookCode.isEmpty ? null : () => context.go('/qr?code=${Uri.encodeComponent(book.bookCode)}'),
                      child: const Text('Pindah ke Scan QR'),
                    ),
                  )
                ],
              ),
            );

            if (!wide) {
              return Column(children: [cover, const SizedBox(height: 24), details]);
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 280, child: cover),
                const SizedBox(width: 24),
                Expanded(child: details),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.bold, fontSize: 14))),
          Expanded(
            child: isStatus
                ? Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: value == 'Tersedia' ? AppTheme.green : AppTheme.red))
                : Text(value.isEmpty ? '-' : value, style: const TextStyle(color: AppTheme.ink, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
