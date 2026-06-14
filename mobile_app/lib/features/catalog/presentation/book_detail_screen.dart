import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';

class BookDetailScreen extends ConsumerWidget {
  final int bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final book = books.firstWhere((b) => b.id == bookId, orElse: () => books.first);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Koleksi', style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 220,
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                image: DecorationImage(image: NetworkImage(book.cover), fit: BoxFit.cover, onError: (e, s) {}),
              ),
            ),
            const SizedBox(height: 24),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(99)),
                    child: Text(book.category, style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(book.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navy, height: 1.2)),
                  const SizedBox(height: 12),
                  Text(book.description, style: const TextStyle(color: AppTheme.muted, fontSize: 14)),
                  const SizedBox(height: 20),
                  const Divider(color: AppTheme.line),
                  const SizedBox(height: 12),
                  _buildMetaRow('Penulis', book.author),
                  _buildMetaRow('Tahun', book.year),
                  _buildMetaRow('Penerbit', book.publisher),
                  _buildMetaRow('ISBN', book.isbn),
                  _buildMetaRow('Status', book.status, isStatus: true),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.line, style: BorderStyle.solid),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_2, size: 40, color: AppTheme.navy),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('QR Code Koleksi', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy)),
                              Text('Gunakan menu scan untuk meminjam buku ini.', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
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
                      onPressed: () {},
                      child: const Text('Pindah ke Scan QR'),
                    ),
                  )
                ],
              ),
            )
          ],
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
              : Text(value, style: const TextStyle(color: AppTheme.ink, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
