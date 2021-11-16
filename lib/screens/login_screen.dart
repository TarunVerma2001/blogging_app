import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:blogging_app/screens/home_page.dart';
import 'package:blogging_app/screens/signUp_screen.dart';
import 'package:blogging_app/services/apiServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool isObscure = true;

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.black38.withOpacity(0.7), Color(0xff191720)],
                  stops: [0.0, 0.5],
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomLeft,
                  tileMode: TileMode.repeated)),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 30, right: 30.0, bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_rounded),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.white,
                            iconSize: 30,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          heading1(),
                          SizedBox(
                            height: 10,
                          ),
                          heading2(),
                          heading3(),
                          SizedBox(
                            height: 30,
                          ),
                          formFields(),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            overTheButtonText(context),
                            SizedBox(
                              height: 10,
                            ),
                            LogInButton()
                          ])
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  logIn(String email, String pass) async {
    // print('inside');

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: avoid_init_to_null
    var jsonResponse = null;

    var res;
    try{
      
      res = await ApiServices().login(email, pass);
      //yet to be implement
    } on DioError catch(e) {
      
    }

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.toString());
      print(jsonResponse);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString('token', jsonResponse['token']);
        print(jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
        //TODO: incorrect message yet to be implemented!
        // SnackBar(content: Text('Email or Password is incorrect!'), duration: Duration(milliseconds: 1000),);
      });
      // print(res.body);
    }
  }

  Column formFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        emailField(),
        SizedBox(height: 40.0),
        passwordField(),
      ],
    );
  }

  GestureDetector LogInButton() {
    return GestureDetector(
      onTap: emailController.text == '' || passwordController.text == ''
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await logIn(emailController.text, passwordController.text);
            },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Sign In',
            style: GoogleFonts.quicksand(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Row overTheButtonText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'don\'t have an account?',
          style: GoogleFonts.quicksand(fontSize: 15, color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return SignUpPage();
            }));
          },
          child: Text(
            ' Register',
            style: GoogleFonts.quicksand(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: passwordController,
      cursorColor: Colors.black,
      obscureText: isObscure,
      style: GoogleFonts.quicksand(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: Colors.white,
          icon: isObscure
              ? Icon(Icons.visibility_rounded)
              : Icon(Icons.visibility_off_rounded),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
        labelText: 'Password',
        labelStyle: GoogleFonts.quicksand(color: Colors.white),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  TextFormField emailField() {
    return TextFormField(
      controller: emailController,
      cursorColor: Colors.white,
      style: GoogleFonts.quicksand(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GoogleFonts.quicksand(color: Colors.white),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Text heading3() {
    return Text(
      'You\'ve been missed!',
      style: GoogleFonts.quicksand(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Text heading2() {
    return Text(
      'Welcome back.',
      style: GoogleFonts.quicksand(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Text heading1() {
    return Text(
      'Let\'s sign you in.',
      style: GoogleFonts.quicksand(
          fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
