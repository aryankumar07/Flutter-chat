import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat APP"),   
      ),
      body: Center(
        child: Text("loading....."),
      ),
    );
  }
}