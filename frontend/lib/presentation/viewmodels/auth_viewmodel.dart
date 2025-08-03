import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  late String backendUrl;
  String? _accessToken;
  String? _refreshToken;
  bool _loading = true;
  Timer? _refreshTimer;

  bool get isAuthenticated => _accessToken != null;
  bool get isLoading => _loading;
  String? get accessToken => _accessToken;

  AuthProvider() {
    backendUrl = dotenv.env["BACKEND_URL"] ?? "http://192.168.1.38:8080:8081/api/auth";
    backendUrl = "http://192.168.1.38:8081/api/auth";
    _init();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _refreshToken = prefs.getString('refreshToken');
    if (_refreshToken != null) {
      await refreshAccessToken();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$backendUrl/sign-in"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['accessToken'];
      _refreshToken = data['refreshToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', _refreshToken!);

      _scheduleRefresh();

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;

    final response = await http.patch(
      Uri.parse("$backendUrl/refresh-token"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': _refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['accessToken'];
      _refreshToken = data['refreshToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', _refreshToken!);

      _scheduleRefresh();
      // no es necesario notificar a los listeners
      // notifyListeners();
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
    }

    logout();
    return false;
  }

  void _scheduleRefresh() {
    _refreshTimer?.cancel();

    if (_accessToken == null) return;

    final duration = _getTokenExpiryDuration(_accessToken!);
    if (duration == null) return;

    // Refrescar 60 segundos antes de que expire
    final refreshIn = duration - Duration(seconds: 60);
    if (refreshIn.isNegative) {
      // Si ya está expirado o próximo a expirar, refrescar inmediatamente
      refreshAccessToken();
      return;
    }

    _refreshTimer = Timer(refreshIn, () {
      refreshAccessToken();
    });
  }

  Duration? _getTokenExpiryDuration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'] as int;
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      return expiryDate.difference(now);
    } catch (e) {
      print('Error leyendo expiración token: $e');
      return null;
    }
  }

  Future<void> logout() async {
    _refreshTimer?.cancel();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('refreshToken');

    _accessToken = null;
    _refreshToken = null;

    notifyListeners();
  }
}
