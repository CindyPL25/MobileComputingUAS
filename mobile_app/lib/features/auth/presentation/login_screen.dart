import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/api_providers.dart';
import '../../../shared/widgets/library_chrome.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final identity = _identityController.text.trim();
    final password = _passwordController.text;
    if (identity.isEmpty || password.isEmpty) {
      _showMessage('Email/NIM dan password wajib diisi.');
      return;
    }

    try {
      final user = await ref.read(authControllerProvider.notifier).login(identity, password);
      ref
        ..invalidate(profileProvider)
        ..invalidate(dashboardProvider)
        ..invalidate(booksProvider)
        ..invalidate(borrowingsProvider)
        ..invalidate(notificationsProvider);
      if (mounted) {
        if (user.role == 'admin') {
          context.go('/admin-dashboard');
        } else {
          context.go('/home');
        }
      }
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: Column(
        children: [
          const LibraryBrandBar(showNav: true),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: LibrarySurfaceCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LibrarySectionHeader(eyebrow: 'Masuk Akun', title: 'Selamat datang kembali'),
                        const SizedBox(height: 24),
                        const Text('Email atau NIM', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _identityController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'nama@student.ac.id / 2201001'),
                        ),
                        const SizedBox(height: 16),
                        const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password',
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          onSubmitted: (_) => isLoading ? null : _login(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            child: Text(isLoading ? 'Memproses...' : 'Login'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => context.push('/register'),
                            child: const Text('Belum punya akun? Daftar sekarang', style: TextStyle(color: AppTheme.navy)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: () => context.push('/admin-login'),
                            child: const Text('Masuk sebagai admin perpustakaan', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
