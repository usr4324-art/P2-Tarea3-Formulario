import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';

import '../services/secure_storage_service.dart';

import 'app_drawer.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();

  String? welcomeMessage;
  bool isLoading = false;

  Future<void> _loadWelcomeMessage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('No hay una sesión activa');
      }

      final response = await _authService.getWelcome(token);

      setState(() {
        welcomeMessage = response.toString();
      });
    } catch (e) {
      setState(() {
        welcomeMessage = 'Error al obtener el mensaje: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  static const Color primaryColor = Color(0xFF1565C0);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Bienvenida'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) =>
              IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await SecureStorageService().deleteToken();

              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome_background.webp'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Color(0x40FFFFFF), BlendMode.darken),
              ),
            ),
          ),
          const Positioned(top: 200, left: 0, right: 0, child: Icon(Icons.landscape, size: 100, color: Colors.white)),
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Black border
                Text(
                  'Islas Canarias',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.satisfy(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.black,
                  ),
                ),

                // White filling
                Text(
                  'Islas Canarias',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.satisfy(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 80,
            left: 10,
            right: 10,
            child: Text(
              'Las mejores experiencias de cada isla en un solo lugar',
              textAlign: TextAlign.center,
              style: GoogleFonts.yesevaOne(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading ? null : _loadWelcomeMessage,
                  icon: const Icon(Icons.waving_hand),
                  label: const Text('Mostrar mensaje de bienvenida'),
                ),
                if (isLoading) const CircularProgressIndicator(),
                if (welcomeMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      welcomeMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
