import 'dart:convert';

import 'package:frontend/presentation/viewmodels/watch_common_viewmodel.dart';
import 'package:http/http.dart' as http;

class WatchSerieViewmodel extends WatchCommonViewmodel {
  WatchSerieViewmodel(): super();

  

  @override
  Future<void> fetchAndInitController(String id) async{
    if (isLoaded) return;
    setLoading(true);
    setError(false);
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$backendUrl/series/episode/$id"));
      final responseBody = jsonDecode(response.body);
      _info = 

    } catch (e) {
      print(e);
      setError(true);
    }

    setLoading(true);
    notifyListeners();
  }
  
  @override
  void changeToNextEpisode() {
    // TODO: implement changeToNextEpisode
  }
  
}