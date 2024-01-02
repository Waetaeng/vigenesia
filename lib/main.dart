import 'package:flutter/material.dart';
import 'package:vigenesia/Screens/EditPage.dart';
import 'package:vigenesia/Screens/Register.dart';
import 'Screens/Login.dart';
import 'Screens/MainScreens.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigenesia',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
