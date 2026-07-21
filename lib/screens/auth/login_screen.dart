import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo con degradado sutil
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.98),
                const Color(0xFFF8FBFF),
              ],
            ),
          ),
        ),

        // Blob animado 1 - arriba izquierda
        Positioned(
          top: -150,
          left: -100,
          child: AnimatedBuilder(
            animation: _controller1,
            builder: (_, __) {
              final offset = Offset(
                _controller1.value * 50 - 25,
                _controller1.value * 60 - 30,
              );
              return Transform.translate(
                offset: offset,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9FE2).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(300),
                  ),
                ),
              );
            },
          ),
        ),

        // Blob animado 2 - abajo derecha
        Positioned(
          bottom: -180,
          right: -120,
          child: AnimatedBuilder(
            animation: _controller2,
            builder: (_, __) {
              final offset = Offset(
                -_controller2.value * 40 + 20,
                -_controller2.value * 50 + 25,
              );
              return Transform.translate(
                offset: offset,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7ACC).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(320),
                  ),
                ),
              );
            },
          ),
        ),

        // Blob animado 3 - centro derecha
        Positioned(
          top: 200,
          right: -80,
          child: AnimatedBuilder(
            animation: _controller3,
            builder: (_, __) {
              final offset = Offset(
                _controller3.value * 45 - 22,
                -_controller3.value * 35 + 17,
              );
              return Transform.translate(
                offset: offset,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5BABF0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(280),
                  ),
                ),
              );
            },
          ),
        ),

        // Blob animado 4 - arriba derecha
        Positioned(
          top: -80,
          right: -60,
          child: AnimatedBuilder(
            animation: _controller1,
            builder: (_, __) {
              final offset = Offset(
                -_controller1.value * 35 + 17,
                _controller1.value * 40 - 20,
              );
              return Transform.translate(
                offset: offset,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BB6F5).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(250),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _keepSession = false;
  bool _submitted = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadKeepSessionPref();
  }

  Future<void> _loadKeepSessionPref() async {
    final keep = await AuthController.getKeepSession();
    if (mounted) setState(() => _keepSession = keep);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return 'Introduce tu email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Email no válido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return 'Introduce tu contraseña';
    return null;
  }

  void _submit() {
    setState(() {
      _submitted = true;
      _errorMessage = null;
    });
    if (!_formKey.currentState!.validate()) return;

    ref.read(authStateProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      keepSession: _keepSession,
    );
  }

  void _showSessionConflictDialog() {
    // Mostrar mensaje en el formulario para que persista tras cerrar el diálogo
    setState(() => _errorMessage =
        'Ya tienes la sesión iniciada en otro dispositivo (plan Basic: 1 sesión simultánea).');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sesión activa en otro dispositivo'),
        content: const Text(
          'Tu cuenta Basic solo permite una sesión activa a la vez.\n\n'
          'Para iniciar sesión aquí debes cerrar la sesión en el otro dispositivo, '
          'o puedes forzar el cierre de todas las sesiones activas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _errorMessage = null);
              ref.read(authStateProvider.notifier).login(
                email: _emailController.text.trim(),
                password: _passwordController.text,
                keepSession: _keepSession,
                forceLogin: true,
              );
            },
            child: const Text('Forzar cierre y continuar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse('https://centerly.app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final authState = ref.watch(authStateProvider);
    final isLoading = authState.when(
      onLoading: () => true,
      onAuthenticated: (_) => false,
      onUnauthenticated: () => false,
      onError: (_) => false,
    );

    ref.listen(authStateProvider, (previous, next) {
      next.when(
        onAuthenticated: (_) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onError: (message) {
          if (next.errorCode == 'SESSION_CONFLICT') {
            _showSessionConflictDialog();
          } else if (next.errorCode == 'EMAIL_NOT_VERIFIED') {
            setState(() => _errorMessage =
                'Debes verificar tu email antes de continuar. Revisa tu bandeja de entrada.');
          } else if (next.errorCode == 'TRIAL_EXPIRED') {
            setState(() => _errorMessage =
                'Tu período de prueba de 14 días ha expirado. Elige un plan para seguir usando Centerly.');
          } else {
            setState(() => _errorMessage = message);
          }
        },
        onLoading: () {},
        onUnauthenticated: () {},
      );
    });

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
    );
    const fieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 15);
    final labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade800,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _AnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 56),

                // Marca
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 72,
                    height: 72,
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'Centerly',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Color(0xFF0D0D0D),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Gestiona tu negocio sin esfuerzo',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(height: 48),

                // Error banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade600, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Colors.red.shade700, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Formulario
                Form(
                  key: _formKey,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Email', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'tu@email.com',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: false,
                          border: fieldBorder,
                          enabledBorder: fieldBorder,
                          focusedBorder: focusedBorder,
                          contentPadding: fieldPadding,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),

                      Text('Contraseña', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: false,
                          border: fieldBorder,
                          enabledBorder: fieldBorder,
                          focusedBorder: focusedBorder,
                          contentPadding: fieldPadding,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => isLoading ? null : _submit(),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 8),

                      // Olvidó contraseña
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Mantener sesión
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () =>
                                setState(() => _keepSession = !_keepSession),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _keepSession,
                                onChanged: isLoading
                                    ? null
                                    : (v) => setState(
                                        () => _keepSession = v ?? false),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                side: BorderSide(color: Colors.grey.shade400),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Mantener sesión iniciada',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Botón principal
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Registro
                      GestureDetector(
                        onTap: _openWebsite,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                            children: [
                              const TextSpan(text: '¿No tienes cuenta?  '),
                              TextSpan(
                                text: 'Regístrate',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
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
