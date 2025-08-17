import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/data/model/film.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:http/http.dart' as http;



class MoviesViewmodel extends ChangeNotifier{
  late String backendUrl;
  final AuthProvider auth;

  bool _loading = false;
  bool _error = false;
  List<Film> _movies = [];

  bool get loading => _loading;
  List<Film> get movies => _movies;
  bool get error => _error;

  MoviesViewmodel(this.auth){
    backendUrl = dotenv.env["BACKEND_URL"]??"http://localhost:8080/virma/api";
  }

  Future<void> fetchMovies() async {
    _loading = true;
    _error = false;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$backendUrl/movie?page=0&size=10"),
        headers: {
          "Authorization": "Bearer ${auth.accessToken}"
        }
      );
      final responseBody = jsonDecode(response.body);
      final List<dynamic> moviesDynamicResponse = responseBody["content"]??[];
      final List<Film> moviesResponse = moviesDynamicResponse.map((item) => Film.fromJson(item)).toList();
      _movies = moviesResponse;
    } catch (e) {
      _error = true;
      print(e);
    }
    _loading = false;
    notifyListeners();
  }
  
}