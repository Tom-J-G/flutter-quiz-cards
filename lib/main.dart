import 'package:flutter/material.dart';

import 'package:quizCards/screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Cards',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          headline4: TextStyle(),
          subtitle1: TextStyle(),
          button: TextStyle(),
          overline: TextStyle(),
          caption: TextStyle(),
          subtitle2: TextStyle(),
          
        ).apply(bodyColor: Colors.white60, displayColor: Colors.white60)
      ),
      home: Home(title: 'Quiz App'),
    );
  }
}