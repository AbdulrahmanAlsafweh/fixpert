import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MaterialApp(

      home:Scaffold(
        // appBar: AppBar(),
        body: Home(),
      )
    );
  }
}
