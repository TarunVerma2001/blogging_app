import 'dart:convert';

import 'package:blogging_app/services/apiServices.dart';
import 'package:blogging_app/utils/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowBlog extends StatefulWidget {
  late String description, author, color, id;

  ShowBlog(
      {required String description,
      required String color,
      required String author,
      required String id}) {
    // this.title = title;
    this.description = description;
    this.author = author;
    // this.likes = likes;
    // this.tag = tag;
    this.color = color;
    this.id = id;
  }

  @override
  ShowBlogState createState() => ShowBlogState();
}

class ShowBlogState extends State<ShowBlog> {
  late String title, likes, tag;
  List<Map> comments = [];
  bool likedToggle = false;
  bool commentsToggle = false;
  bool likeToggle = false;
  bool pageLoaded = false;

  updateBlog() async {
    var response = await ApiServices().getBlog(widget.id);
    var jsonResponse = json.decode(response.toString());
    print(jsonResponse);
    print('inside setState');
    print(jsonResponse['data']['blog']['likes']);
    likes = jsonResponse['data']['blog']['likes'].toString();
    title = jsonResponse['data']['blog']['title'].toString();
    // author = jsonResponse['data']['blog']['author'].toString();
    tag = jsonResponse['data']['blog']['tag'].toString();
    pageLoaded  = true;
    setState(() {});
  }

  getComments() async {
    comments = await Utils().getBlog(widget.id);
    setState(() {});
  }

  likedByUser() async {
    var response = await ApiServices().likedByUser(widget.id);
    var responseJson = json.decode(response.toString());
    // print('responseJson: ');
    // print(responseJson['data']['liked']);
    if (responseJson['data']['liked'] == true) {
      likedToggle = true;
    } else {
      likedToggle = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    updateBlog();
    getComments();
    likedByUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: appBar(),
        ),
        body: !pageLoaded ? Center(child: Container(height: 80, width: 80, child: CircularProgressIndicator())) : Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              //about author
              authorInfo(),
              SizedBox(
                height: 30,
              ),
              titleSection(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //LIKES AND COMMENTS
              likesAndComments(),
              SizedBox(
                height: 10,
              ),
              image(context),
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
                          color: Colors.black,
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
                          color: Colors.white,
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
                                  color: Colors.blue,
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
                                  color: Colors.black,
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
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),
      ),
    );
  }

  Container image(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 9 / 16,
      color: Color(int.parse(widget.color.toString())),
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
                fontSize: 23, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 3,
          ),
          GestureDetector(
              onTap: () async {
                var response = await ApiServices().updateLike(widget.id);
                if (response.statusCode == 200) {
                  likedByUser();
                  updateBlog();
                  setState(() {});
                } else {
                  var snackBar = SnackBar(
                      content: Text('Can\'t like or dislike, Srver Error!'),
                      duration: Duration(milliseconds: 1500));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
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
            '14',
            style: GoogleFonts.roboto(
                fontSize: 23, color: Colors.grey, fontWeight: FontWeight.w500),
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
                color: Colors.blue, size: 23),
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
            fontSize: 35, color: Colors.black, fontWeight: FontWeight.w500),
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
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Icon(
                Icons.person,
                size: 40,
              ),
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
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '5min Read',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey,
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
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(top: 25.0, right: 30),
      //     child: Builder(
      //       builder: (context) => GestureDetector(
      //         onTap: () {},
      //         child: Icon(
      //           CupertinoIcons.search,
      //           size: 35,
      //           color: Color(0xff200E32).withOpacity(0.7),
      //         ),
      //       ),
      //     ),
      //   ),
      // ],
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
            color: Color(0xff200E32).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
