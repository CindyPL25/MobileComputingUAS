import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

Widget buildAdminDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.navy, AppTheme.navySoft]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.local_library, color: AppTheme.navy),
              ),
              const Spacer(),
              const Text('Menu Admin', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('Mobile E-Library Kampus', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            Navigator.pop(context);
            context.go('/admin-dashboard');
          },
        ),
        ListTile(
          leading: const Icon(Icons.library_books),
          title: const Text('Manajemen Buku'),
          onTap: () {
            Navigator.pop(context);
            context.push('/admin-books');
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Monitoring Peminjaman'),
          onTap: () {
            Navigator.pop(context);
            context.push('/admin-borrowings');
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: const Text('Manajemen QR'),
          onTap: () {
            Navigator.pop(context);
            context.push('/admin-qr');
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Manajemen Pengguna'),
          onTap: () {
            Navigator.pop(context);
            context.push('/admin-users');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profil Admin'),
          onTap: () {
            Navigator.pop(context);
            context.push('/admin-profile');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            context.go('/landing');
          },
        ),
      ],
    ),
  );
}
