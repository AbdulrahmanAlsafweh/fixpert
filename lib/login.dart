import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChooseTheAccountType.dart';
import 'package:testing/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String displayError = "";
  String baseURL = "https://switch.unotelecom.com/fixpert/login";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String email = Uri.encodeComponent(emailController.text);
    String password = Uri.encodeComponent(passwordController.text);
    print(email);
    print(password);
    // if(passwordController.text != confirm_passwordController.text)
    //   displayError = "password not identical";
    // else{
    String url = '$baseURL?user_email=$email&user_password=$password';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('message')) {
        // setState(() {
        //   displayError="";
        //   displayError=responseData['message'];
        //
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            responseData['message'],
          ),
          duration: Duration(seconds: 3),
          backgroundColor: responseData['message'].toLowerCase().contains('failed') && responseData['message'].toLowerCase().contains("exist") ? Colors.red : Colors.green,
        ));
      }
      print(response.body);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          // title: Text("Login"),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("assets/logo.png"),
                  width: screenWidth - (screenWidth * 0.4),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              if (displayError.isNotEmpty)
                Text(
                  displayError,
                  style: TextStyle(fontSize: 13),
                ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.05),
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Email"),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.05),
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Password"),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF1A80E5)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChooseAcountType(),));
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF0F2F5)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                ),
              )
            ],
          ),
        ));
  }
}