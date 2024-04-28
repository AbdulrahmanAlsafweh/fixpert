import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing/login.dart';
import 'home.dart';
import 'getServices.dart';

class Signup extends StatelessWidget {
  final String? accType;

  Signup({Key? key, this.accType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(accType);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirm_passwordController = TextEditingController();

    Future<void> signup() async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String baseURL = 'https://switch.unotelecom.com/fixpert/signup.php';
      String email = Uri.encodeComponent(emailController.text).trim();
      String password = Uri.encodeComponent(passwordController.text).trim();
      if (passwordController.text.trim() !=
          confirm_passwordController.text.trim())
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The passwords doesn't match"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      else {
        String url = '$baseURL?user_email=$email&user_password=$password';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
            duration: Duration(seconds: 3),
            backgroundColor:
                responseData['message'].toLowerCase().contains('exist')
                    ? Colors.red
                    : Colors.green,
          ));

          /////////////////////////////////////////////////////////////////////////////
          //i know that if the account created successfully the response message will be
          // weclome aboard! so i will save that the user logged in if i catch a word welcome
          /////////////////////////////////////////////////////////////////////////////

          if (responseData['message'].toLowerCase().contains('welcome')) {
            sp.setBool("loggedIn", true);

            // Navigate to the home page to trigger rebuild
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else {
            sp.setBool("loggedIn", false);
          }
        }
      }
    }

    Future<void> checkIfWorkerExistst() async {
      String baseURL ="https://switch.unotelecom.com/fixpert/checkIfWorkerExists.php";
      // SharedPreferences sp = await SharedPreferences.getInstance();
      String email = Uri.encodeComponent(emailController.text).trim();
      String password = Uri.encodeComponent(passwordController.text).trim();

      if (passwordController.text.trim() !=confirm_passwordController.text.trim()){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The passwords doesn't match"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));}
      else {
        String url='$baseURL?user_email=$email';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          responseData['message'].toLowerCase().contains('signed up')
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(responseData['message']),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ))
              :  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Services(email: email,password: password,),));


        }
      }
    }

    return Scaffold(
        appBar: AppBar(
            // title: Text("Signup"),
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
                'Create an account',
                style: TextStyle(fontSize: 24),
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
                width: screenWidth - (screenWidth * 0.05),
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: confirm_passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Re-Write password"),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.1),

                //The sign up button
                child: accType == "client"
                    ? ElevatedButton(
                        onPressed: () {
                          signup();
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF1A80E5)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                      )

                    //The continue button which will appear if the user is worker
                    : ElevatedButton(
                        onPressed: () {
                          checkIfWorkerExistst();
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Services(email: emailController.text,password: passwordController.text,),));
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF1A80E5)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth - (screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'I have an account',
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
