import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_task/homepage.dart';
import 'package:wallpaper_task/services.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WallpaperProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      home: HomePage(),
    );
  }
}
