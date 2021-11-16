import 'dart:convert';

import 'package:blogging_app/services/apiServices.dart';
import 'package:flutter/cupertino.dart';

class Utils {
  var blogsResponse;
  var blogsResponseJson = null;
  var blogResponse;
  var blogResponseJson = null;

  List<Map<String, String>> pageBuilder = [
    {
      'image': 'assets/images/welcome.svg',
      'text': 'Welcome to the Blogging World!'
    },
    {
      'image': 'assets/images/book_lover.svg',
      'text': 'Find a new Source of knowledge for Yourself!'
    },
    {
      'image': 'assets/images/typewriter.svg',
      'text': 'Create a Unique Blog to Publish your Passion!'
    },
  ];

  List<String> topics = [
    'All Topics',
    'Programming',
    'Technology',
    'Design',
  ];

  getAllBlogs() async {
    List<Map> cards = [];
    blogsResponse = await ApiServices().getAllBlogs();
    blogsResponseJson = json.decode(blogsResponse.toString());
    // print(blogsResponseJson['data']['blog'][0]);
    var blogsData = blogsResponseJson['data']['blog'];

    for (int i = 0; i < blogsData.length; i++) {
      Map tmp = {
        'image': i % 2 == 0
            ? 'assets/images/programming.svg'
            : 'assets/images/freelancer.svg',
        'title': blogsData[i]['title'].toString(),
        'id': blogsData[i]['_id'],
        'tag': blogsData[i]['tag'].toString(),
        'likes': blogsData[i]['likes'].toString(),
        'author': blogsData[i]['author']['name'].toString(),
        'duration': '5 min Read',
        'color': '0xff94B3FD',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      };
      cards.add(tmp);
    }
    print(cards.length);
    return cards;
  }

  getBlog(String id) async {
    List<Map> comments = [];
    blogResponse = await ApiServices().getBlog(id);
    blogResponseJson = json.decode(blogResponse.toString());
    print(blogResponseJson['data']['blog']['comments']);
    var blogData = blogResponseJson['data']['blog']['comments'];

    for (int i = 0; i < blogData.length; i++) {
      Map tmp = {
        'comment': blogData[i]['comment'],
        'userName': blogData[i]['user']['name'],
        'userId': blogData[i]['user']['name'],
      };

      comments.add(tmp);
    }

    print(comments.length);
    return comments;
  }
}
