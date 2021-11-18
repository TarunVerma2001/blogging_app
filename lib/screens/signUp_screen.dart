import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:blogging_app/screens/home_page.dart';
import 'package:blogging_app/screens/login_screen.dart';
import 'package:blogging_app/services/apiServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordConfirmController =
      new TextEditingController();

  bool isObscure = true;
  bool isObscure1 = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                Colors.black38.withOpacity(0.7),
                Color(0xff191720),
              ],
                  stops: [
                0.0,
                0.5
              ],
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
                          heading(),
                          formFields(),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            overTheButtonText(),
                            SizedBox(
                              height: 10,
                            ),
                            signUpButton()
                          ])
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  signUp(String name, String email, String password,
      String passwordConfirm) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var res =
          await ApiServices().signUp(name, email, password, passwordConfirm);

      var jsonResponse = json.decode(res.toString());
      // print(jsonResponse);

      setState(() {
        _isLoading = false;
      });
      sharedPreferences.setString('token', jsonResponse['token']);
      // print(jsonResponse['token']);
      var snackBar = SnackBar(
          content: Text('Succesfully Registered!'),
          duration: Duration(milliseconds: 1500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    } on DioError catch (e) {
      print(e.response);
      var snackBar = SnackBar(
          content: Text(e.response!.data['message']),
          duration: Duration(milliseconds: 2500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
      // print(e.response!.data['message']);
      // print(e.response);
    }
  }

  Column formFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        nameField(),
        SizedBox(height: 20.0),
        emailField(),
        SizedBox(height: 20.0),
        passwordField(),
        SizedBox(height: 20.0),
        passwordConfirmField(),
      ],
    );
  }

  GestureDetector signUpButton() {
    return GestureDetector(
      onTap: emailController.text == '' ||
              nameController.text == '' ||
              passwordController.text == '' ||
              passwordConfirmController.text == ''
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await signUp(nameController.text, emailController.text,
                  passwordController.text, passwordConfirmController.text);
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
            'Sign Up',
            style: GoogleFonts.quicksand(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Row overTheButtonText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'have an account?',
          style: GoogleFonts.quicksand(fontSize: 15, color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          },
          child: Text(
            ' Sign In',
            style: GoogleFonts.quicksand(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  TextFormField passwordConfirmField() {
    return TextFormField(
      controller: passwordConfirmController,
      cursorColor: Colors.black,
      obscureText: isObscure1,
      style: GoogleFonts.quicksand(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: Colors.white,
          icon: isObscure1
              ? Icon(Icons.visibility_rounded)
              : Icon(Icons.visibility_off_rounded),
          onPressed: () {
            setState(() {
              isObscure1 = !isObscure1;
            });
          },
        ),
        labelText: 'Confirm Password',
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

  TextFormField nameField() {
    return TextFormField(
      controller: nameController,
      cursorColor: Colors.white,
      style: GoogleFonts.quicksand(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Name',
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

  Text heading() {
    return Text(
      'Let\'s get you Registered.',
      style: GoogleFonts.quicksand(
          fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
