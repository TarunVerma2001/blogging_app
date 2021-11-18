import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:blogging_app/services/apiServices.dart';
import 'package:blogging_app/utils/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowBlog extends StatefulWidget {
  late String description, author, id;

  ShowBlog(
      {required String description,
      required String author,
      required String id}) {
    this.description = description;
    this.author = author;

    this.id = id;
  }

  @override
  ShowBlogState createState() => ShowBlogState();
}

class ShowBlogState extends State<ShowBlog> {
  late String title, likes, tag, image;
  List<Map> comments = [];
  bool likedToggle = false;
  bool commentsToggle = false;
  bool likeToggle = false;
  bool pageLoaded = false;

  getBlog() async {
    try {
      var response = await ApiServices().getBlog(widget.id);
      var jsonResponse = json.decode(response.toString());

      likes = jsonResponse['data']['blog']['likes'].toString();
      title = jsonResponse['data']['blog']['title'].toString();
      image = jsonResponse['data']['blog']['image'].toString();
      tag = jsonResponse['data']['blog']['tag'].toString();
      pageLoaded = true;
    } on DioError catch (e) {
      var snackBar = SnackBar(
          content: Text(e.response!.data['message']),
          duration: Duration(milliseconds: 2500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {});
  }

  getComments() async {
    try {
      comments = await Utils().getBlog(widget.id);
    } on DioError catch (e) {
      var snackBar = SnackBar(
          content: Text(e.response!.data['message']),
          duration: Duration(milliseconds: 2500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {});
  }

  likedByUser() async {
    try {
      var response = await ApiServices().likedByUser(widget.id);
      var responseJson = json.decode(response.toString());

      if (responseJson['data']['liked'] == true) {
        likedToggle = true;
      } else {
        likedToggle = false;
      }
    } on DioError catch (e) {
      var snackBar = SnackBar(
          content: Text(e.response!.data['message']),
          duration: Duration(milliseconds: 2500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {});
  }

  @override
  void initState() {
    getBlog();
    getComments();
    likedByUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1B262C),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: appBar(),
        ),
        body: !pageLoaded
            ? Center(
                child: Container(
                    height: 80, width: 80, child: CircularProgressIndicator()))
            : Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    //about author
                    authorInfo(),
                    SizedBox(
                      height: 10,
                    ),
                    titleSection(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Divider(
                        height: 2,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    likesAndComments(),
                    SizedBox(
                      height: 10,
                    ),
                    imageSection(context),
                    SizedBox(
                      height: 10,
                    ),
                    description(),
                    //for comments
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    commentsToggle ? allComments() : Container(),
                  ],
                ),
              ),
      ),
    );
  }

  Column allComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: new List.generate(
        comments.length + 1,
        (i) {
          return i == 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Comments',
                      style: GoogleFonts.roboto(
                          color: Color(0xff3282B8),
                          fontSize: 30,
                          fontWeight: FontWeight.w400)),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Colors.black12)
                          ],
                          color: Color(0xff1B262C),
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(comments[i - 1]['userName'],
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Color(0xff0F4C75),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(comments[i - 1]['comment'],
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Color(0xffBBE1FA),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      )),
                );
        },
      ),
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        widget.description,
        style: GoogleFonts.roboto(
            fontSize: 18, color: Color(0xffBBE1FA), fontWeight: FontWeight.w300),
      ),
    );
  }

  Padding imageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight:Radius.circular(20)),
          child: Image(
            height: 500,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }

  Padding likesAndComments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          //likes
          Text(
            likes,
            style: GoogleFonts.roboto(
                fontSize: 23, color: Color(0xff3282B8), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 3,
          ),
          GestureDetector(
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                var token = sharedPreferences.getString('token');
                if (token == null) {
                  var snackBar = SnackBar(
                      content: Text('Please Log In to Like Blog!'),
                      duration: Duration(milliseconds: 1500));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                try {
                  var response = await ApiServices().updateLike(widget.id);
                  // if (response.statusCode == 200) {
                  likedByUser();
                  getBlog();
                  setState(() {});
                } on DioError catch (e) {
                  var snackBar = SnackBar(
                      content: Text(e.response!.data['message']),
                      duration: Duration(milliseconds: 2500));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                // } else {
                //   var snackBar = SnackBar(
                //       content: Text('Can\'t like or dislike, Server Error!'),
                //       duration: Duration(milliseconds: 1500));
                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // }
              },
              child: Icon(
                  likedToggle
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: Colors.pink,
                  size: 23)),
          SizedBox(
            width: 10,
          ),
          //comments
          Text(
            comments.length.toString(),
            style: GoogleFonts.roboto(
                fontSize: 23, color: Color(0xff3282B8), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                commentsToggle = !commentsToggle;
              });
            },
            child: Icon(CupertinoIcons.text_bubble_fill,
                color: Color(0xff3282B8), size: 23),
          ),
        ],
      ),
    );
  }

  Padding titleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        title,
        style: GoogleFonts.roboto(
            fontSize: 35,
            color: Color(0xffBBE1FA),
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Padding authorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Color(0xffBBE1FA),
                borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Icon(Icons.person, size: 40, color: Color(0xff1B262C)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.author,
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Color(0xffBBE1FA),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '5min Read',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Color(0xff3282B8),
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shadowColor: Colors.white,
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 00,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 30),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.back,
            size: 35,
            color: Color(0xffBBE1FA).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
