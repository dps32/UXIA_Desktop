import 'package:flutter/material.dart';

class MainView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 500,
        color: Colors.pink,
      ),
    );
  }

}