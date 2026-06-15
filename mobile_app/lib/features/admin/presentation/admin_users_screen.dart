import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  Future<void> _updateUserStatus(UserModel user, String newStatus) async {
    try {
      await ref.read(apiRepositoryProvider).updateUser({'id': user.id, 'status': newStatus});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status diubah menjadi $newStatus')));
        ref.invalidate(adminUsersProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.red));
      }
    }
  }

  Future<void> _updateUserRole(UserModel user, String newRole) async {
    try {
      await ref.read(apiRepositoryProvider).updateUser({'id': user.id, 'role': newRole});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Role diubah menjadi $newRole')));
        ref.invalidate(adminUsersProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: usersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (users) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminUsersProvider),
          child: ListView(
            children: [
              LibraryContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LibrarySurfaceCard(
                      child: LibrarySectionHeader(
                        eyebrow: 'Pengguna',
                        title: 'Data Pengguna',
                        subtitle: 'Kelola status dan role pengguna (mahasiswa).',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Total user: ${users.length}', style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    if (users.isEmpty)
                      const LibrarySurfaceCard(child: Text('Belum ada pengguna terdaftar.', style: TextStyle(color: AppTheme.muted)))
                    else
                      LibraryResponsiveGrid(
                        minTileWidth: 360,
                        children: users.map((user) => _UserTile(
                              user: user,
                              onToggleStatus: () => _updateUserStatus(user, user.status == 'aktif' ? 'nonaktif' : 'aktif'),
                              onToggleRole: () => _updateUserRole(user, user.role == 'mahasiswa' ? 'admin' : 'mahasiswa'),
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

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user, required this.onToggleStatus, required this.onToggleRole});

  final UserModel user;
  final VoidCallback onToggleStatus;
  final VoidCallback onToggleRole;

  @override
  Widget build(BuildContext context) {
    final isAktif = user.status == 'aktif';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy, fontSize: 16)),
                    Text(user.nim, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAktif ? AppTheme.gold.withValues(alpha: 0.1) : AppTheme.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(user.status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAktif ? AppTheme.gold : AppTheme.red)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(user.email, style: const TextStyle(color: AppTheme.ink, fontSize: 14)),
          Text('Role: ${user.role.toUpperCase()}', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.line),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onToggleStatus,
                  child: Text(isAktif ? 'Nonaktifkan' : 'Aktifkan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onToggleRole,
                  child: Text(user.role == 'mahasiswa' ? 'Jadikan Admin' : 'Jadikan Mahasiswa'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
