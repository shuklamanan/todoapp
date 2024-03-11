import 'package:flutter/material.dart';
import 'package:todoapp/pages/loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      debugShowCheckedModeBanner: false,
      home: const loginpage(),
      theme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
    );
  }
}
