import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/dummy_data_provider.dart';
import 'widgets/admin_drawer.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MAHASISWA', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Data pengguna aplikasi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.navy)),
            const SizedBox(height: 8),
            const Text('Kelola akun mahasiswa yang akan memakai layanan mobile e-library.', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Tambah Mahasiswa'),
              ),
            ),
            const SizedBox(height: 16),
            ...users.map((user) =>
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.line),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.navy,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.name.substring(0, 1),
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.navy)),
                          Text('${user.nim} · ${user.major}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                          Text(user.email, style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.status == 'Aktif' ? AppTheme.green.withValues(alpha: 0.1) : AppTheme.muted.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: user.status == 'Aktif' ? AppTheme.green : AppTheme.muted),
                      ),
                      child: Text(user.status, style: TextStyle(color: user.status == 'Aktif' ? AppTheme.green : AppTheme.muted, fontWeight: FontWeight.bold, fontSize: 10)),
                    )
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
