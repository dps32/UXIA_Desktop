import 'package:flutter/material.dart';
import 'package:uxiadesktop/main.dart';

class MainView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              MainApp.data.setSessionId('');
              MainApp.sd.token = null;
            },
          )
        ],
      ),
      body: Container(
        height: 500,
        width: 500,
        color: Colors.pink,
      ),
    );
  }

}