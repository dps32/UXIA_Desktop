import 'package:flutter/material.dart';
import 'package:uxiadesktop/views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hola Mundo!"),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        body: Center(
          child: LoginView(),
        ),
      ),
    );
  }
}