import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/auth/bloc/auth_cubit.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';

// --- ALDRICH COLOR PALETTE ---
class _AldrichColors {
  static const voidBlack = Color(0xFF001219);
  static const midnightGreen = Color(0xFF005F73);
  static const champagnePink = Color(0xFFE9D8A6);
  static const cambridgeBlue = Color(0xFF94D2BD);
  static const gamboge = Color(0xFFEE9B00);
  static const blueMunsell = Color(0xFF0A9396);
  static const rubyRed = Color(0xFF9B2226);
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AuthCubit>();
      if (_isLogin) {
        cubit.signIn(_emailController.text, _passwordController.text);
      } else {
        cubit.signUp(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RootPage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: _AldrichColors.rubyRed,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: _AldrichColors.voidBlack,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _AldrichColors.voidBlack,
                  _AldrichColors.midnightGreen,
                ],
                stops: [0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _AldrichColors.champagnePink, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _AldrichColors.gamboge.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.music_note,
                            size: 48,
                            color: _AldrichColors.champagnePink,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Title
                        Text(
                          _isLogin ? "WELCOME BACK" : "CREATE ACCOUNT",
                          style: const TextStyle(
                            color: _AldrichColors.champagnePink,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin
                              ? "Sign in to continue your journey"
                              : "Join the Quavo experience",
                          style: const TextStyle(
                            color: _AldrichColors.cambridgeBlue,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Name Field (Register only)
                        if (!_isLogin) ...[
                          _buildTextField(
                            controller: _nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Email Field
                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Password Field
                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onToggleObscure: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Confirm Password (Register only)
                        if (!_isLogin) ...[
                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: "Confirm Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscureConfirmPassword,
                            onToggleObscure: () {
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Submit Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => _handleSubmit(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _AldrichColors.rubyRed,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Neubrutalism sharp corners
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _isLogin ? "SIGN IN" : "REGISTER",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Toggle Mode Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? "Don't have an account? "
                                  : "Already have an account? ",
                              style: const TextStyle(
                                color: _AldrichColors.cambridgeBlue,
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleMode,
                              child: Text(
                                _isLogin ? "Register" : "Sign In",
                                style: const TextStyle(
                                  color: _AldrichColors.blueMunsell,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      style: const TextStyle(color: _AldrichColors.champagnePink),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _AldrichColors.cambridgeBlue),
        prefixIcon: Icon(icon, color: _AldrichColors.cambridgeBlue),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _AldrichColors.gamboge,
                ),
              )
            : null,
        filled: false,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _AldrichColors.cambridgeBlue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _AldrichColors.gamboge, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _AldrichColors.rubyRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _AldrichColors.rubyRed, width: 2),
        ),
        errorStyle: const TextStyle(color: _AldrichColors.rubyRed),
      ),
    );
  }
}
