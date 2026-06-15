import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/admin/presentation/admin_books_screen.dart';
import '../../features/admin/presentation/admin_borrowings_screen.dart';
import '../../features/admin/presentation/admin_qr_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../features/admin/presentation/admin_profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/catalog/presentation/book_detail_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/landing_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/qr/presentation/qr_scanner_screen.dart';
import '../../shared/presentation/main_wrapper.dart';
import '../../shared/providers/api_providers.dart';

// Route zone definitions
const _mahasiswaRoutes = {'/home', '/qr', '/history', '/profile', '/notifications'};
const _adminRoutes = {
  '/admin-dashboard',
  '/admin-books',
  '/admin-borrowings',
  '/admin-qr',
  '/admin-users',
  '/admin-profile',
};

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter(ValueNotifier<bool> authNotifier) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ProviderScope.containerOf(context, listen: false)
          .read(authControllerProvider);

      final path = state.uri.path;

      // 1. While auth is loading, do not redirect — avoid blank screen
      if (authState.isLoading) return null;

      final user = authState.valueOrNull;

      final isMahasiswaRoute = _mahasiswaRoutes.contains(path);
      final isAdminRoute = _adminRoutes.contains(path);
      final isLoginPage = path == '/login' || path == '/register' || path == '/admin-login';

      // 2. User not logged in
      if (user == null) {
        if (isAdminRoute || isMahasiswaRoute) return '/login';
        return null; // allow public routes
      }

      // 3. Unknown role → logout and redirect to login
      if (user.role != 'admin' && user.role != 'mahasiswa') {
        ProviderScope.containerOf(context, listen: false)
            .read(authControllerProvider.notifier)
            .logout();
        return '/login';
      }

      // 4. Logged in, trying to access login/register pages → redirect to dashboard
      if (isLoginPage) {
        return user.role == 'admin' ? '/admin-dashboard' : '/home';
      }

      // 5. Admin accessing mahasiswa-only routes (except /profile which is shared)
      if (user.role == 'admin' && isMahasiswaRoute && path != '/profile') {
        return '/admin-dashboard';
      }

      // 6. Mahasiswa accessing admin routes
      if (user.role == 'mahasiswa' && isAdminRoute) {
        return '/home';
      }

      // 7. All good — allow navigation
      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/admin-login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin-books',
        builder: (context, state) => const AdminBooksScreen(),
      ),
      GoRoute(
        path: '/admin-borrowings',
        builder: (context, state) => const AdminBorrowingsScreen(),
      ),
      GoRoute(
        path: '/admin-qr',
        builder: (context, state) => const AdminQrScreen(),
      ),
      GoRoute(
        path: '/admin-users',
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin-profile',
        builder: (context, state) => const AdminProfileScreen(),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return BookDetailScreen(bookId: int.tryParse(id) ?? 1);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: '/qr',
            builder: (context, state) =>
                QrScannerScreen(initialBookCode: state.uri.queryParameters['code']),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
    ],
  );
}
