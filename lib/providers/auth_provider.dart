import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthProvider extends ChangeNotifier {
  String? _uid;
  bool _isLoading = false;
  String? _errorMessage;

  String? get uid => _uid;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(bool isLogin, String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      if (isLogin) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _uid = user.uid;
        final idToken = await user.getIdToken();
        if (!isLogin) {
          await http.post(
            Uri.parse('http://localhost:8080/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': idToken}),
          );
        }
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _uid = null;
    notifyListeners();
  }

  Future<void> authUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();
    final authResponse = await http.post(
      Uri.parse('http://localhost:8080/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
    if (!authResponse.body.contains("Invalid token")) {
      _uid = authResponse.body.split("Authenticated UID: ")[0];
      notifyListeners();
    }
  }

  void resetErr() {
    _errorMessage = null;
    notifyListeners();
  }
}
