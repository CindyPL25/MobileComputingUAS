import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';
import 'widgets/admin_drawer.dart';

class AdminBooksScreen extends ConsumerWidget {
  const AdminBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MANAJEMEN BUKU', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Data koleksi perpustakaan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.navy)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Form buku dummy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navy)),
                  const SizedBox(height: 4),
                  const Text('Belum tersimpan ke database', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Judul Buku', hintText: 'Masukkan judul buku')),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Penulis', hintText: 'Nama penulis')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: 'Teknologi',
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: const ['Teknologi', 'Sistem Informasi', 'Database', 'Mobile Computing', 'Keamanan Web']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: 'Tersedia',
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const ['Tersedia', 'Dipinjam']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () {}, child: const Text('Simpan Dummy')),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daftar buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navy)),
                Text('${books.length} koleksi', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            ...books.map((book) =>
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.cream,
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(image: NetworkImage(book.cover), fit: BoxFit.cover, onError: (e, s) {}),
                          ),
                          child: const Icon(Icons.image_not_supported, color: Colors.black12, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy), maxLines: 2, overflow: TextOverflow.ellipsis),
                              Text(book.author, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${book.publisher} (${book.year})', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: book.status == 'Tersedia' ? AppTheme.green.withValues(alpha: 0.1) : AppTheme.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: book.status == 'Tersedia' ? AppTheme.green : AppTheme.red),
                                    ),
                                    child: Text(book.status, style: TextStyle(color: book.status == 'Tersedia' ? AppTheme.green : AppTheme.red, fontWeight: FontWeight.bold, fontSize: 10)),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
