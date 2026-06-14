import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString(), style: const TextStyle(color: AppTheme.red), textAlign: TextAlign.center)),
        data: (user) => SingleChildScrollView(
          child: LibraryContent(
            maxWidth: 980,
            child: Column(
              children: [
                LibraryResponsiveGrid(
                  minTileWidth: 360,
                  children: [
                    LibrarySurfaceCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(color: AppTheme.navy, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navy)),
                          Text(user.major.isEmpty ? user.role : user.major, style: const TextStyle(color: AppTheme.muted)),
                        ],
                      ),
                    ),
                    LibrarySurfaceCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Informasi akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navy)),
                          const SizedBox(height: 16),
                          _buildProfileRow('Nama Lengkap', user.name),
                          const Divider(color: AppTheme.line),
                          _buildProfileRow('NIM', user.nim),
                          const Divider(color: AppTheme.line),
                          _buildProfileRow('Email', user.email),
                          const Divider(color: AppTheme.line),
                          _buildProfileRow('Jurusan', user.major.isEmpty ? '-' : user.major),
                          const Divider(color: AppTheme.line),
                          _buildProfileRow('Status', user.status),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _NotificationsPreview(state: notificationsState),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                      ref
                        ..invalidate(profileProvider)
                        ..invalidate(dashboardProvider)
                        ..invalidate(booksProvider)
                        ..invalidate(borrowingsProvider)
                        ..invalidate(notificationsProvider);
                      if (context.mounted) context.go('/landing');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.red,
                      side: const BorderSide(color: AppTheme.red),
                    ),
                    child: const Text('Logout'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value.isEmpty ? '-' : value, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _NotificationsPreview extends StatelessWidget {
  const _NotificationsPreview({required this.state});

  final AsyncValue<List<NotificationModel>> state;

  @override
  Widget build(BuildContext context) {
    return LibrarySurfaceCard(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navy)),
              TextButton(onPressed: () => context.push('/notifications'), child: const Text('Lihat semua')),
            ],
          ),
          state.when(
            loading: () => const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
            error: (error, _) => Text(error.toString(), style: const TextStyle(color: AppTheme.red, fontSize: 12)),
            data: (items) {
              if (items.isEmpty) return const Text('Belum ada notifikasi.', style: TextStyle(color: AppTheme.muted));
              return Column(
                children: items.take(2).map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.navy)),
                    subtitle: Text(item.message, maxLines: 2, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
