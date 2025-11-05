// lib/features/auth/providers/auth_provider.dart

import 'package:demo25/services/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register() async {
    _isLoading = true;
    _errorMessage = null;
    _token = null;
    notifyListeners(); // Notify all listeners to rebuild

    try {
      await AuthService().register();
      _token = 'mock_token_12345';
      _isLoading = false;
      Logger().i('Registration successful. Token: $_token');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      Logger().e('Registration failed: $e');
    }
    notifyListeners(); // Notify listeners of the final state
  }

  void reset() {
    _token = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

