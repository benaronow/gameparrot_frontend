import 'package:flutter/material.dart';
import 'package:gameparrot/theme.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'styled_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, AppColors.darkBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gray),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: .08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Welcome Back!' : 'Create Account',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  if (authProvider.errorMessage != null) ...[
                    Text(
                      authProvider.errorMessage!,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  StyledInput(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  StyledInput(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
                  if (authProvider.isLoading)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => authProvider.login(
                          isLogin,
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        ),
                        child: Text(isLogin ? 'Login' : 'Create Account'),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primaryBlue,
                        elevation: 0,
                        side: BorderSide(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final userCredential = await authProvider
                              .googleLogin();
                          print(
                            'Logged in as ${userCredential.user?.displayName}',
                          );
                        } catch (e) {
                          print('Login failed: $e');
                        }
                      },
                      icon: Image.asset('assets/google.png', height: 20),
                      label: const Text('Sign in with Google'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _toggleMode();
                      authProvider.resetErr();
                    },
                    child: Text(
                      isLogin
                          ? 'Don\'t have an account? Create one'
                          : 'Already have an account? Login',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
