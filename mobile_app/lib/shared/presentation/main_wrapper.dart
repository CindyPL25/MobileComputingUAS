import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/catalog');
        break;
      case 2:
        context.go('/qr');
        break;
      case 3:
        context.go('/history');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final currentIndex = switch (path) {
      '/catalog' => 1,
      '/qr' => 2,
      '/history' => 3,
      '/profile' => 4,
      _ => 0,
    };
    final isWide = MediaQuery.sizeOf(context).width >= 920;
    final destinations = const [
      _NavDestination(Icons.home_outlined, Icons.home, 'Home'),
      _NavDestination(Icons.search_outlined, Icons.search, 'Katalog'),
      _NavDestination(Icons.qr_code_scanner_outlined, Icons.qr_code_scanner, 'Scan'),
      _NavDestination(Icons.history_outlined, Icons.history, 'Riwayat'),
      _NavDestination(Icons.person_outline, Icons.person, 'Profil'),
    ];

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppTheme.navy,
              selectedIndex: currentIndex,
              onDestinationSelected: _onItemTapped,
              extended: true,
              minExtendedWidth: 206,
              leading: const Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 28),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RailLogo(),
                    SizedBox(width: 10),
                    Text('Menu Mahasiswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              selectedIconTheme: const IconThemeData(color: AppTheme.gold),
              unselectedIconTheme: IconThemeData(color: Colors.white.withValues(alpha: 0.72)),
              selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
              unselectedLabelTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.74), fontWeight: FontWeight.w700),
              destinations: destinations
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.activeIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        items: destinations
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
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
