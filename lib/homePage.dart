import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Center(
                child: (Image.asset('assets/homeLogo.png')),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget> [


        ],
      ),
    );
  }
}
