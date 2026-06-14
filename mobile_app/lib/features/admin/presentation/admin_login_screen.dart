import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('Admin E-Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                const Text('PANEL PENGELOLA', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Masuk sebagai admin', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 8),
                const Text('Gunakan tampilan ini untuk simulasi akses petugas perpustakaan.', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                const SizedBox(height: 24),
                const Text('Email Admin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                const TextField(decoration: InputDecoration(hintText: 'admin@kampus.ac.id')),
                const SizedBox(height: 16),
                const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Masukkan password')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/admin-dashboard'),
                    child: const Text('Masuk Admin'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Kembali ke login mahasiswa', style: TextStyle(color: AppTheme.navy)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
