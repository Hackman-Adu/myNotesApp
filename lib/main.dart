import 'package:flutter/material.dart';
import 'package:noteApp/screens/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme: SliderThemeData(
              thumbColor: Colors.white,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.5),
              disabledThumbColor: Colors.white.withOpacity(0.5),
              disabledActiveTrackColor: Colors.white.withOpacity(0.5),
              trackHeight: 0.50,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16)),
          brightness: Brightness.dark,
          primaryColor: Color(0xff0c2233),
          primaryColorDark: Color(0xff0c2233),
          accentColor: Color(0xff101820),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplasScreen());
  }
}
