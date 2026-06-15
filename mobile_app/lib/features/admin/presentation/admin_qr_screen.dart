import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminQrScreen extends ConsumerWidget {
  const AdminQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kode QR Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: booksState.when(
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
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppTheme.line),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: book.bookCode.isEmpty
                                    ? const Center(child: Icon(Icons.qr_code_2, color: Colors.black26, size: 36))
                                    : QrImageView(
                                        data: book.bookCode,
                                        version: QrVersions.auto,
                                        size: 70.0,
                                      ),
                              ),
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
