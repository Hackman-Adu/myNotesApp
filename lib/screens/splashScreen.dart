import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteApp/screens/home.dart';
import 'package:noteApp/util/utils.dart';

class SplasScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplasScreen> {
  @override
  void initState() {
    super.initState();
    this.initializeTimer();
  }

  void initializeTimer() {
    Timer(Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "My Notes",
                style: TextStyle(fontSize: 50, fontFamily: "Bulletto Killa"),
              ),
              SizedBox(height: 40),
              Utils.showPinnerDialog()
            ],
          )),
    );
  }
}
