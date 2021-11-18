
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  //TODO: handle errors

  login(String email, String pass) async {
    var dio = new Dio();

    Map data = {'email': email, 'password': pass};

    try {
      var response = await dio
          .post('http://192.168.43.212:8000/api/v1/users/login', data: data);
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  signUp(String name, String email, String password,
      String passwordConfirm) async {
    var dio = new Dio();
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm
    };

    try {
      var response = await dio
          .post('http://192.168.43.212:8000/api/v1/users/signup', data: data);

      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('token');
  }

  getAllBlogs() async {
    var dio = new Dio();
    try {
      var response = await dio.get('http://192.168.43.212:8000/api/v1/blogs');
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  getBlog(String id) async {
    var dio = new Dio();
    try {
      var response =
          await dio.get('http://192.168.43.212:8000/api/v1/blogs/${id}');
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  uploadImage(String path) async {
    var dio = new Dio();

    var token = await getToken();

    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(path),
    });

    dio.options.headers['Authorization'] = "Bearer ${token}";

    try {
      var response = await dio.post('http://192.168.43.212:8000/api/v1/blogs/uploadImage',
          data: formData);

      print(response.toString());
      return response;
    } on DioError catch (e) {
      print(e.response);
      throw e;
    }
  }

  createBlog(String title, String description, String tag, String img) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'tag': tag,
      'image': img,
    };

    dio.options.headers['Authorization'] = "Bearer ${token}";

    try {
      var response =
          await dio.post('http://192.168.43.212:8000/api/v1/blogs', data: data);

      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  likedByUser(String blogId) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {'blog': blogId};

    dio.options.headers['Authorization'] = "Bearer ${token}";

    try {
      var response = await dio.post(
          'http://192.168.43.212:8000/api/v1/blogs/likedByUser',
          data: data);

      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  updateLike(String blogId) async {
    var dio = new Dio();
    var token = await getToken();

    Map<String, dynamic> data = {'blog': blogId};

    dio.options.headers['Authorization'] = "Bearer ${token}";

    try {
      var response = await dio.patch(
          'http://192.168.43.212:8000/api/v1/blogs/updateLikes',
          data: data);

      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  getMe() async {
    var token = await getToken();

    try {
      var response = await http.get(
          Uri.parse('http://192.168.43.212:8000/api/v1/users/me'),
          headers: {
            'Authorization': 'Bearer $token',
          });
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }
}
