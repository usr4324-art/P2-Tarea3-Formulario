
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  final SecureStorageService _storage = SecureStorageService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final token = await _storage.getToken();

      if (token == null || token.isEmpty) {
        if (mounted) context.go('/login');
        return;
      }

      final response = await _authService.checkToken(token);

      if (response['error'] == true) {
        await _storage.deleteToken();
        if (mounted) context.go('/login');
        return;
      }

      if (mounted) context.go('/');
    } catch (e) {
      await _storage.deleteToken();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
