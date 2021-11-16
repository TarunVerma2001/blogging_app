import 'dart:convert';

import 'package:blogging_app/screens/showBlog.dart';
import 'package:blogging_app/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blogging_app/utils/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> topics = new Utils().topics;
List<Map> cards = [];
int active = 0;
var User = null;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  getPage(BuildContext context) {
    if (index == 0) {
      return homePage(context);
    } else {
      return profilePage();
    }
  }

  getAllBlogs() async {
    cards = await Utils().getAllBlogs();
    setState(() {});
  }

  refreshTheBlogs() async {
    cards = await Utils().getAllBlogs();
  }

  getCurrentUser() async {
    var token = await ApiServices().getToken();
    if (token == null) {
      return null;
    }
    var tmp = await ApiServices().getMe();
    User = json.decode(tmp.body)['data']['user'];
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    getAllBlogs();
    super.initState();
  }

  var scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // refreshTheBlogs();
    // getAllBlogs();
    // getCurrentUser();
    // setState(() {});  // to refresh whole page when it builds the page

    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          height: 100.0,
          width: 100.0,
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {
                Navigator.pushNamed(context, '/createBlog');
              },
              backgroundColor: Color(0xff3F3D56),
              splashColor: Colors.teal,
              child: Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          currentIndex: index,
          onTap: (newIndex) => setState(() => index = newIndex),
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home_rounded,
                  size: 40,
                ),
                label: ' '),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.person_outline_outlined, size: 40),
                label: ' '),
          ],
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: appBar(),
        ),
        drawer: appDrawer(context),
        body: getPage(context),
        // body: homePage(context),
      ),
    );
  }

  Container profilePage() {
    return Container(
      height: 100,
      width: 100,
      color: Colors.teal,
    );
  }

  Container homePage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          date(),
          helloMessage(),
          // List of Topics
          topicList(),
          SizedBox(height: 20),
          popularBlogs(),
          popularBlogsCards(context),
        ],
      ),
    );
  }

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff3D52AF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.tealAccent,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                Text(
                  'Hello',
                  style: GoogleFonts.roboto(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5,
                ),
                User != null
                    ? Text(
                        User['name'],
                        style: GoogleFonts.roboto(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    : Container(),
              ],
            ),
          ),
          User != null
              ? Container()
              : ListTile(
                  minLeadingWidth: 20,
                  minVerticalPadding: 10,
                  title: Text(
                    'Sign In',
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/logIn');
                    // Navigator.pop(context);
                  },
                ),
          User != null
              ? Container()
              : Divider(
                  height: 2,
                  thickness: 1,
                ),
          User != null
              ? Container()
              : ListTile(
                  title: Text(
                    'Sign Up',
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/signUp');
                    // Navigator.pop(context);
                  },
                ),
          User != null
              ? Container()
              : Divider(
                  height: 2,
                  thickness: 1,
                ),
          User != null
              ? ListTile(
                  title: Text(
                    'Log Out',
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.clear();

                    setState(() {
                      User = null;
                    });
                    // Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0, right: 30),
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {},
              child: Icon(
                CupertinoIcons.search,
                size: 35,
                color: Color(0xff200E32).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
      shadowColor: Colors.white,
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 00,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 30),
        child: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                Scaffold.of(context).openDrawer();
              });
            },
            child: Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              size: 40,
              color: Color(0xff200E32),
            ),
          ),
        ),
      ),
    );
  }

  Container helloMessage() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          'Hello, there',
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container date() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          '25 October 2021',
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container popularBlogsCards(BuildContext context) {
    return Container(
      height: 360,
      width: MediaQuery.of(context).size.width,
      child: cards.length == 0
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, i) {
                return i == 0
                    ? Container(
                        width: 20,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Container(
                              width: 220,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    color: Colors.black12,
                                  )
                                ],
                              ),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      );
              })
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: cards.length + 1,
              itemBuilder: (context, i) {
                return i == 0
                    ? Container(
                        width: 20,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowBlog(
                                id: cards[i - 1]['id'],
                                description: cards[i - 1]['description'],
                                author: cards[i - 1]['author'],
                                color: cards[i - 1]['color'],
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Container(
                                  width: 220,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(int.parse(cards[i - 1]['color'])),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        color: Colors.black12,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 220,
                                        width: 180,
                                        child: SvgPicture.asset(
                                          cards[i - 1]['image'].toString(),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                right: 10,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  child: Text(
                                                    cards[i - 1]['tag']
                                                        .toString()
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xffFF8C8C),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(cards[i - 1]
                                                                ['likes']
                                                            .toString() +
                                                        '🖤'),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              cards[i - 1]['title'].toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          children: [
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 90,
                                                    child: Text(
                                                      cards[i - 1]['author']
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 90,
                                                    child: Text(
                                                      cards[i - 1]['duration']
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  height: 120,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 4,
                                        color: Colors.black12,
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
            ),
    );
  }

  Padding popularBlogs() {
    // int selectedValPopUpMenu = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular',
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Container topicList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: topics.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  active = i;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      active != i ? Colors.grey.withOpacity(0.3) : Colors.black,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      topics[i].toString(),
                      style: GoogleFonts.roboto(
                        color: active == i ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
