import 'package:blogging_app/screens/createBlog.dart';
import 'package:blogging_app/screens/home_page.dart';
import 'package:blogging_app/screens/login_screen.dart';
import 'package:blogging_app/screens/onboarding.dart';
import 'package:blogging_app/screens/signUp_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/homePage',  
      routes: {
        '/OnBoarding': (context) => OnBoarding(),
        '/homePage': (context) => HomePage(),
        '/logIn': (context) => LoginScreen(),
        '/signUp': (context) => SignUpPage(),
        '/createBlog':(context) => CreateBlog(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
    );
  }
}
