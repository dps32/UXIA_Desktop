import 'package:flutter/material.dart';
import 'package:uxiadesktop/infrastructure/app_data.dart';
import 'package:uxiadesktop/infrastructure/file_reader.dart';
import 'package:uxiadesktop/parsers/saved_data.dart';
import 'package:uxiadesktop/views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static AppData data = AppData();
  static SavedData sd = SavedData(null, null);
  static FileReader fr = FileReader();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LoginView(bxConstraints: constraints);
            }
          ) 
        ),
      ),
    );
  }
}