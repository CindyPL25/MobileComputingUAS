import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('Mobile E-Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.line),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AKUN BARU', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Registrasi mahasiswa', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 12),
                const Text(
                  'Endpoint registrasi tidak tersedia pada API mobile saat ini. Buat akun melalui website PHP Native atau minta admin menambahkan mahasiswa.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Kembali ke Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
