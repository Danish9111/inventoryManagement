import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../layout/app_shell.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // In a real app, you might want to handle 'AuthChecking' state with a loading spinner
    // specifically if the check takes time. Here we assume fast check or default to Login.

    if (authState is AuthSuccess) {
      return const AppShell();
    }

    return const LoginScreen();
  }
}
