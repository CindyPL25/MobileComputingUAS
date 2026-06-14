import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';
import 'widgets/admin_drawer.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final users = ref.watch(usersProvider);
    final history = ref.watch(historyProvider);
    final qrScans = ref.watch(qrScansProvider);

    final borrowedCount = history.where((i) => i.status == 'Dipinjam').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(onPressed: () => context.push('/admin-profile'), icon: const Icon(Icons.person)),
          IconButton(onPressed: () => context.go('/landing'), icon: const Icon(Icons.logout))
        ],
      ),
      drawer: buildAdminDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Text('PANEL ADMIN', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Kelola katalog dan peminjaman', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.navy)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton(onPressed: () => context.push('/admin-books'), child: const Text('Tambah Buku'))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: AppTheme.navy, side: const BorderSide(color: AppTheme.line)),
                          onPressed: () => context.push('/admin-qr'),
                          child: const Text('Lihat QR'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Buku', books.length.toString(), Icons.library_books, AppTheme.navy)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Mahasiswa', users.length.toString(), Icons.people, AppTheme.gold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Dipinjam', borrowedCount.toString(), Icons.book_online, AppTheme.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('QR Scan', qrScans.length.toString(), Icons.qr_code, AppTheme.muted)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PEMINJAMAN TERBARU', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Status transaksi', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
                TextButton(onPressed: () => context.push('/admin-borrowings'), child: const Text('Lihat semua'))
              ],
            ),
            const SizedBox(height: 12),
            ...history.take(3).map((item) {
              Color statusColor;
              if (item.status.toLowerCase() == 'dikembalikan') {
                statusColor = AppTheme.green;
              } else if (item.status.toLowerCase() == 'terlambat') {
                statusColor = AppTheme.red;
              } else {
                statusColor = AppTheme.gold;
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.navy), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${item.borrowedAt} - ${item.returnedAt}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(item.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            const Text('QR SCAN TERBARU', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...qrScans.map((scan) =>
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scan.book, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.navy), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${scan.student} · ${scan.location}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                        Text(scan.result, style: const TextStyle(fontSize: 10, color: AppTheme.green, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Text(scan.time, style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navy)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
