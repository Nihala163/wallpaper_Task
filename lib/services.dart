import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_task/json.dart';

class WallpaperProvider extends ChangeNotifier {
  List<Wallpaper> _wallpapers = [];
  bool _isLoading = false;
  int _page = 1;

  List<Wallpaper> get wallpapers => _wallpapers;
  bool get isLoading => _isLoading;

  Future<void> fetchWallpapers() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    var url =
        'https://api.unsplash.com/photos/random?client_id=NpwmTryQkK4AFOm79mA8Do-Q8CjOaaXOb2t9fNJBkVM&query=food&count=6&page=$_page';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        var res = jsonDecode(response.body);
        if (res is List && res.isNotEmpty) {
          List<Wallpaper> wallpapersList =
              res.map((item) => Wallpaper.fromJson(item)).toList();
          _wallpapers.addAll(wallpapersList);
          _page++;
        }
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Failed to load wallpapers, Status Code: ${response.statusCode}');
    }

    _isLoading = false;
    notifyListeners();
  }
}
