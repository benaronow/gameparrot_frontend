import 'package:flutter/material.dart';
import 'package:gameparrot/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
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

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Create Account')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (authProvider.errorMessage != null) ...[
              Text(
                authProvider.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 8),
            ],
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => authProvider.login(
                      isLogin,
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    ),
                    child: Text(isLogin ? 'Login' : 'Create Account'),
                  ),
            TextButton(
              onPressed: () => {_toggleMode(), authProvider.resetErr()},
              child: Text(
                isLogin
                    ? 'Don\'t have an account? Create one'
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
