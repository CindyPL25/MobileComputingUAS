import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class AdminQrScreen extends ConsumerWidget {
  const AdminQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksProvider);

    return LibraryAdminPage(
      child: booksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (books) => ListView(
          children: [
            LibraryContent(
              child: Column(
                children: [
                  const LibrarySurfaceCard(
                    child: LibrarySectionHeader(
                      eyebrow: 'QR Code',
                      title: 'Kode QR dari database',
                      subtitle: 'Kode buku berasal dari /books dan bisa dipindai di menu Scan.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (books.isEmpty)
                    const LibrarySurfaceCard(child: Text('Belum ada kode QR buku dari backend.', style: TextStyle(color: AppTheme.muted)))
                  else
                    LibraryResponsiveGrid(
                      minTileWidth: 320,
                      children: books.map((book) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.line)),
                          child: Row(
                            children: [
                              const Icon(Icons.qr_code_2, color: AppTheme.navy, size: 36),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text(book.bookCode.isEmpty ? '-' : book.bookCode, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('${book.availableStock}/${book.stock}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
