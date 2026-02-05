import 'package:dream_pos/constants/appColors.dart';
import 'package:dream_pos/constants/app_images.dart';
import 'package:dream_pos/screens/products/widgets/product_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../../layout/app_shell.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      await ref
          .read(authProvider.notifier)
          .register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            width: 400,
          ),
        );
      } else if (next is AuthSuccess) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 900;

          if (isWideScreen) {
            return Row(
              children: [
                // 1. Branding Side (Left Panel)
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image
                      Image.asset(AppImages.backgroundImage, fit: BoxFit.cover),

                      // Color overlay
                      Container(color: AppColors.primaryBlue.withOpacity(0.7)),

                      // Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.wlogo, height: 100),
                          const SizedBox(height: 20),
                          const Text(
                            'Dream POS',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Join us and manage with ease.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(48.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: _buildSignupForm(authState),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Mobile / Tablet Portrait View
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: _buildSignupForm(authState),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignupForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Text(
            'Create Account',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign up to get started',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          ProductTextField(
            label: 'Full Name',
            controller: _nameController,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 10),

          ProductTextField(
            label: 'Email Address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 10),
          ProductTextField(
            suffixIcon: _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            onTap: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            label: 'Password',
            controller: _passwordController,
            keyboardType: TextInputType.text,
            obscureText: !_isPasswordVisible,
          ),

          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: authState is AuthLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: authState is AuthLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Switch to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
