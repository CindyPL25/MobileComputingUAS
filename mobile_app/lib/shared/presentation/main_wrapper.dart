import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../providers/api_providers.dart';
import '../widgets/library_chrome.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  void _onAdminItemTapped(int index) {
    switch (index) {
      case 0: context.go('/admin-dashboard'); break;
      case 1: context.go('/admin-books'); break;
      case 2: context.go('/admin-borrowings'); break;
      case 3: context.go('/admin-qr'); break;
      case 4: context.go('/admin-users'); break;
      case 5: context.go('/admin-profile'); break;
    }
  }

  void _onMahasiswaItemTapped(int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/catalog'); break;
      case 2: context.go('/qr'); break;
      case 3: context.go('/history'); break;
      case 4: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final isWide = MediaQuery.sizeOf(context).width >= 920;

    final user = ref.watch(authControllerProvider).valueOrNull;
    final isLoggedIn = user != null;
    final isAdmin = isLoggedIn && user.role == 'admin';

    // Public layout (not logged in): full-width with top nav only
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: AppTheme.cream,
        body: Column(
          children: [
            const LibraryBrandBar(showNav: true),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    // Admin layout
    if (isAdmin) {
      final adminDestinations = const [
        _NavDestination(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
        _NavDestination(Icons.menu_book_outlined, Icons.menu_book, 'Buku'),
        _NavDestination(Icons.swap_horiz_outlined, Icons.swap_horiz, 'Peminjaman'),
        _NavDestination(Icons.qr_code_outlined, Icons.qr_code, 'QR'),
        _NavDestination(Icons.people_outline, Icons.people, 'Pengguna'),
        _NavDestination(Icons.manage_accounts_outlined, Icons.manage_accounts, 'Profil'),
      ];

      final adminCurrentIndex = switch (path) {
        '/admin-books' => 1,
        '/admin-borrowings' => 2,
        '/admin-qr' => 3,
        '/admin-users' => 4,
        '/admin-profile' => 5,
        _ => 0,
      };

      if (isWide) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                backgroundColor: AppTheme.navy,
                selectedIndex: adminCurrentIndex,
                onDestinationSelected: _onAdminItemTapped,
                extended: true,
                minExtendedWidth: 188,
                leading: const Padding(
                  padding: EdgeInsets.fromLTRB(12, 16, 12, 28),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RailLogo(),
                      SizedBox(width: 10),
                      Text('Admin Panel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                selectedIconTheme: const IconThemeData(color: AppTheme.gold),
                unselectedIconTheme: IconThemeData(color: Colors.white.withValues(alpha: 0.72)),
                selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                unselectedLabelTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontWeight: FontWeight.w700),
                destinations: adminDestinations.map((item) => NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: Text(item.label),
                )).toList(),
              ),
              Expanded(child: widget.child),
            ],
          ),
        );
      }

      return Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: adminCurrentIndex,
          onTap: _onAdminItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.navy,
          items: adminDestinations.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          )).toList(),
        ),
      );
    }

    // Mahasiswa layout
    final mahasiswaDestinations = const [
      _NavDestination(Icons.home_outlined, Icons.home, 'Home'),
      _NavDestination(Icons.search_outlined, Icons.search, 'Katalog'),
      _NavDestination(Icons.qr_code_scanner_outlined, Icons.qr_code_scanner, 'Scan'),
      _NavDestination(Icons.history_outlined, Icons.history, 'Riwayat'),
      _NavDestination(Icons.person_outline, Icons.person, 'Profil'),
    ];

    final mahasiswaCurrentIndex = switch (path) {
      '/catalog' => 1,
      '/qr' => 2,
      '/history' => 3,
      '/profile' => 4,
      _ => 0,
    };

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppTheme.navy,
              selectedIndex: mahasiswaCurrentIndex,
              onDestinationSelected: _onMahasiswaItemTapped,
              extended: true,
              minExtendedWidth: 188,
              leading: const Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 28),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RailLogo(),
                    SizedBox(width: 10),
                    Text('E-Library', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              selectedIconTheme: const IconThemeData(color: AppTheme.gold),
              unselectedIconTheme: IconThemeData(color: Colors.white.withValues(alpha: 0.72)),
              selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
              unselectedLabelTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontWeight: FontWeight.w700),
              destinations: mahasiswaDestinations.map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: Text(item.label),
              )).toList(),
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mahasiswaCurrentIndex,
        onTap: _onMahasiswaItemTapped,
        items: mahasiswaDestinations.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        )).toList(),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _RailLogo extends StatelessWidget {
  const _RailLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.local_library, color: AppTheme.navy, size: 19),
    );
  }
}
