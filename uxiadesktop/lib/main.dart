import 'package:flutter/material.dart';
import 'package:uxiadesktop/infrastructure/app_data.dart';
import 'package:uxiadesktop/views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static AppData data = AppData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /* appBar: AppBar(
          title: Text("Hola Mundo!"),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ), */
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