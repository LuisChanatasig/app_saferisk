import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  late AnimationController _shakeController;
  late Animation<double> _offsetAnimation;

  Position? _ubicacion;
  bool _isLoading = false;
  bool _loginError = false;

  String? _userError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionAlCargar();

    // Animación de temblor
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

_offsetAnimation = Tween<double>(begin: 0, end: 8).animate(
  CurvedAnimation(
    parent: _shakeController,
    curve: Curves.elasticIn,
  ),
);

  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // Ubicación
  Future<void> _obtenerUbicacionAlCargar() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        final posicion = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _ubicacion = posicion;
        });
      } catch (e) {
        debugPrint("❌ Error obteniendo ubicación: $e");
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Validación de login
  Future<void> _login() async {
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    setState(() {
      _userError = username.isEmpty ? 'Ingrese su usuario' : null;
      _passError = password.isEmpty ? 'Ingrese su contraseña' : null;
      _loginError = false;
    });

    if (_userError != null || _passError != null) {
      _shakeController.forward(from: 0); // Animar campos si están vacíos
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (username == "admin" && password == "1234") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _loginError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales inválidas")),
      );
    }

    setState(() => _isLoading = false);
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Funcionalidad aún no implementada")),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005A95);
    const errorColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final offset = _offsetAnimation.value;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/splash.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 10),

                // UsuarioR
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F7),
                    errorText: _userError,
                  ),
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    errorText: _passError,
                  ),
                ),
                const SizedBox(height: 12),

                // ¿Olvidaste tu contraseña?
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 13,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2.5,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _loginError ? errorColor : primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),

                const SizedBox(height: 40),

                // Versión
                const Text(
                  "Versión 1.0.0 © 2025 Saferisk",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
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
