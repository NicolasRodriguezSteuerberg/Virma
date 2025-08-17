import 'dart:convert';

import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/data/model/serie_info.dart';

class SerieViewmodel extends ChangeNotifier {
  late String backendUrl;
  int serieId;
  final AuthProvider auth;

  bool _loading = false;
  bool _error = false;
  SerieInfo? _serie = null;

  bool get loading => _loading;
  SerieInfo? get serie => _serie;
  bool get error => _error;

  SerieViewmodel(this.serieId, this.auth){
    backendUrl = dotenv.env["BACKEND_URL"]??"http://localhost:8080/virma/api";
  }

  Future<void> fetchSerie() async {
    _loading = true;
    _error = false;
    notifyListeners();
    try {
      print("hola");
      final response = await http.get(
        Uri.parse("$backendUrl/series/info/$serieId"),
        headers: {
          "Authorization": "Bearer ${auth.accessToken}"
        }
      );
      if (response.statusCode != 200) throw Exception("No se pudo recoger la serie");
      final responseBody = jsonDecode(response.body);
      _serie = SerieInfo.fromJson(responseBody);

    } catch (e) {
      _error = true;
      print(e);
    }
    _loading = false;
    notifyListeners();
  }
}