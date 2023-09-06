import 'dart:async';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'package:provider/provider.dart';
import 'data_provider_class.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Authenticate()
           )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 110, 16, 211),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Center(
            child: Column(children: [
              Icon(Icons.shopping_cart, color: Colors.white,size: 50),
              SizedBox(height: 10),
              Text('ShopEasy',style: TextStyle(color: Colors.white, fontSize: 25), )
            ],),
          ),
        ),
      ),
    );
  }
}