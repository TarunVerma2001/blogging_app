import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiServices {
  //TODO: handle errors

  login(String email, String pass) async {
    var dio = new Dio();
    try {
      Map data = {'email': email, 'password': pass};

      try {
        var response = await dio
            .post('http://192.168.43.212:8000/api/v1/users/login', data: data);

        return response;
      } on DioError catch (e) {
        Fluttertoast.showToast(
            msg: e.response!.data['message'],
            // msg: 'hello',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 16.0);
        print(e.response!.data['message']);
      }
    } catch (err) {
      print('Error');
      print(err);
    }
  }
  // if (e.response != null) {
  //   print(e.response!.data);
  // } else {
  //   // Something happened in setting up or sending the request that triggered an Error
  //   print(e.requestOptions);
  //   // print(e.message);
  // }

  signUp(String name, String email, String password,
      String passwordConfirm) async {
    var dio = new Dio();
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm
    };

    var response = await dio
        .post('http://192.168.43.212:8000/api/v1/users/signup', data: data);

    return response;
  }

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('token');
  }

  getAllBlogs() async {
    var dio = new Dio();
    var response = await dio.get('http://192.168.43.212:8000/api/v1/blogs');
    return response;
  }

  getBlog(String id) async {
    var dio = new Dio();
    var response =
        await dio.get('http://192.168.43.212:8000/api/v1/blogs/${id}');
    return response;
  }

  uploadImage(String path) async {
    var token = await getToken();

    var response = await http
        .post(Uri.parse('http://192.168.43.212:8000/api/v1/blogs'), headers: {
      'Authorization': 'Bearer $token',
    }).catchError((err) => print(err));
  }

  createBlog(String title, String description, String tag) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'tag': tag,
    };

    dio.options.headers['Authorization'] = "Bearer ${token}";

    var response = await dio
        .post('http://192.168.43.212:8000/api/v1/blogs', data: data)
        .catchError((err) {
      print(err);
    });

    return response;
  }

  likedByUser(String blogId) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {'blog': blogId};

    dio.options.headers['Authorization'] = "Bearer ${token}";

    var response = await dio
        .post('http://192.168.43.212:8000/api/v1/blogs/likedByUser', data: data)
        .catchError((err) {
      print(err);
    });

    // print('liked by user: ');
    print(response.toString());

    return response;
  }

  updateLike(String blogId) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {'blog': blogId};

    dio.options.headers['Authorization'] = "Bearer ${token}";

    var response = await dio
        .patch('http://192.168.43.212:8000/api/v1/blogs/updateLikes',
            data: data)
        .catchError((err) {
      print(err);
    });

    print('liked by user: ');
    print(response.toString());

    return response;
  }

  getMe() async {
    var token = await getToken();

    return await http
        .get(Uri.parse('http://192.168.43.212:8000/api/v1/users/me'), headers: {
      'Authorization': 'Bearer $token',
    }).catchError((err) => print(err));
  }
}
