import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/data/model/user_state.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/data/model/series.dart';


class BrowseSeriesViewmodel extends ChangeNotifier{
  late String backendUrl;
  bool _firstGet = false;

  bool _loading = false;
  bool _error = false;
  List<Series> _series = [];

  bool get loading => _loading;
  List<Series> get series => _series;
  bool get error => _error;
  bool get firstTry => _firstGet;

  BrowseSeriesViewmodel(){
    backendUrl = dotenv.env["BACKEND_URL"]??"http://localhost:8080/virma/api";
  }

  void changeFirstTry () {
    _firstGet = true;
    notifyListeners();
  }

  Future<void> fetchSeries() async {
    _loading = true;
    _error = false;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$backendUrl/series?page=0&size=10"));
      final responseBody = jsonDecode(response.body);
      final List<dynamic> seriesDynamicResponse = responseBody["content"]??[];
      final List<Series> seriesResponse = seriesDynamicResponse.map((item) => Series.fromJson(item)).toList();
      _series = seriesResponse;
    } catch (e) {
      _error = true;
      print(e);
    }
    _loading = false;
    notifyListeners();
  }
  
}