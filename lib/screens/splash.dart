import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading..."),   
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}