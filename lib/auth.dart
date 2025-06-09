import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  final void Function(String) onLoginSuccess;

  const AuthScreen({super.key, required this.onLoginSuccess});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = FirebaseAuth.instance;
      if (isLogin) {
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      // Notify parent of successful login or registration
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        widget.onLoginSuccess(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Create Account')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
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
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text(isLogin ? 'Login' : 'Create Account'),
                  ),
            TextButton(
              onPressed: _toggleMode,
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
