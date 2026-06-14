import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';
import 'widgets/admin_drawer.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      drawer: buildAdminDrawer(context),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red))),
        data: (dashboard) => LibraryContent(
          maxWidth: 760,
          child: LibrarySurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LibrarySectionHeader(
                  eyebrow: 'Mahasiswa',
                  title: 'Data pengguna aplikasi',
                  subtitle: 'Kelola user lengkap melalui website admin PHP Native.',
                ),
                const SizedBox(height: 12),
                Text('Total user di backend: ${dashboard.totalUsers}', style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Endpoint API mobile belum menyediakan daftar user atau CRUD user. Kelola user melalui website admin PHP Native.', style: TextStyle(color: AppTheme.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
