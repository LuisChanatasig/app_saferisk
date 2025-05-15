import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ⏳ Animación de zoom in del logo
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutCubic),
    );

    _scaleController.forward();

    // ⏭️ Redirige al login después de 5 segundos
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Color(0xFFDFF2FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌟 Logo con efecto zoom in
            ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/splash.png',
                width: 300,
                height: 220,
              ),
            ),

            const SizedBox(height: 60),

            // 🔄 Loader de carga
            const CircularProgressIndicator(
              color: Colors.black54,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
