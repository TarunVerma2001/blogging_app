import 'dart:convert';
import 'dart:ui';
import 'package:blogging_app/screens/profile_screen.dart';
import 'package:dio/dio.dart';
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

  getAllBlogs() async {
    try {
      cards = await Utils().getAllBlogs();
    } on DioError catch (e) {
      var snackBar = SnackBar(
          content: Text(e.response!.data['message']),
          duration: Duration(milliseconds: 2500));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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

  // var scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1B262C),
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          child: FloatingActionButton(
            tooltip: 'Create Blog',
            elevation: 100,
            onPressed: () {
              Navigator.pushNamed(context, '/createBlog');
            },
            backgroundColor: Color(0xffBBE1FA),
            splashColor: Color(0xff0F4C75),
            child: Icon(
              Icons.add_rounded,
              size: 40,
              color: Color(0xff1B262C),
            ),
          ),
        ),
        appBar: appBar(),
        drawer: appDrawer(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: heading(title: 'Hello', size: 30),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: heading(title: 'Popular Blogs', size: 25),
                ),
                popularBlogsCards(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: heading(title: 'All Blogs', size: 25),
                ),
                categoriesCards(),
              ]),
        ),
      ),
    );
  }

  categoriesCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 400,
        width: double.infinity,
        // color: Colors.teal,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (context, i) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff0F4C75),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 2,
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                    children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                            height: 100,
                            width: 100,
                            image: NetworkImage(
                              cards[i]['image'].toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            child: Column(
                              children: [
                                
                              ]
                            ),
                          ),
                        )
                    ],
                    
                  ),
                      ))),
            );
          },
        ),
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

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff3282B8),
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
                      color: Color(0xff0F4C75),
                      size: 40,
                    ),
                  ),
                ),
                Text(
                  'Hello',
                  style: GoogleFonts.roboto(
                      fontSize: 35,
                      color: Color(0xff1B262C),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5,
                ),
                User != null
                    ? Text(
                        User['name'],
                        style: GoogleFonts.quicksand(
                            fontSize: 22,
                            color: Color(0xff1B262C),
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
                        color: Color(0xffBBE1FA),
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
                        color: Color(0xffBBE1FA),
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
                        color: Color(0xffBBE1FA),
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
          padding: const EdgeInsets.only(top: 0.0, right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Icon(
              Icons.person_outline_rounded,
              size: 40,
              color: Color(0xffBBE1FA),
            ),
          ),
        ),
      ],
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 20),
        child: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              setState(() {
                Scaffold.of(context).openDrawer();
              });
            },
            child: Icon(
              Icons.menu_rounded,
              size: 40,
              color: Color(0xffBBE1FA),
            ),
          ),
        ),
      ),
    );
  }

  Container heading({required String title, required double size}) {
    return Container(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: GoogleFonts.roboto(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Color(0xffBBE1FA)),
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
                                color: Color(0xff1B262C),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    color: Colors.black12,
                                  )
                                ],
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xff0F4C75)),
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
                                      // color: Color(
                                      //     int.parse(cards[i - 1]['color'])),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          color: Colors.black12,
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        image: NetworkImage(
                                          cards[i - 1]['image'].toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              Positioned(
                                bottom: 40,
                                right: 10,
                                child: Container(
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
                                    color: Color(0xffBBE1FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
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
                                                      color: Color(0xff3282B8),
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
                                                    child: Text(
                                                      cards[i - 1]['likes']
                                                              .toString() +
                                                          " "
                                                              '❤️',
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff3282B8),
                                                      ),
                                                    ),
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
                                                  color: Color(0xff1B262C),
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
                                                        color:
                                                            Color(0xff0F4C75),
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
                                                        color:
                                                            Color(0xff0F4C75),
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

  // Container popularBlogsCards(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     child: cards.length == 0
  //         ? Center(
  //             child: Container(
  //                 height: 80, width: 80, child: CircularProgressIndicator()),
  //           )
  //         : ListView.builder(
  //             physics: BouncingScrollPhysics(),
  //             scrollDirection: Axis.vertical,
  //             itemCount: cards.length < 5 ? cards.length : 5,
  //             itemBuilder: (context, i) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(
  //                   top: 20.0,
  //                 ),
  //                 child: GestureDetector(
  //                   onTap: () => Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => ShowBlog(
  //                         id: cards[i]['id'],
  //                         description: cards[i]['description'],
  //                         author: cards[i]['author'],
  //                         color: cards[i]['color'],
  //                       ),
  //                     ),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 30,
  //                         ),
  //                         child: Container(
  //                           height: MediaQuery.of(context).size.width * 1.2,
  //                           width: MediaQuery.of(context).size.width,
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(20),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 blurRadius: 10,
  //                                 spreadRadius: 5,
  //                                 color: Colors.grey,
  //                               )
  //                             ],
  //                           ),
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(20.0),
  //                             child: Image(
  //                               image: NetworkImage(
  //                                 cards[i]['image'].toString(),
  //                               ),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         bottom: 10,
  //                         left: 40,
  //                         child: Container(
  //                           child: Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 10.0),
  //                             child: Column(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceBetween,
  //                                       children: [
  //                                         Container(
  //                                           width: 110,
  //                                           child: Text(
  //                                             cards[i]['tag']
  //                                                 .toString()
  //                                                 .toUpperCase(),
  //                                             maxLines: 1,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             style: GoogleFonts.roboto(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Color(0xffFF8C8C),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         Container(
  //                                           padding: EdgeInsets.all(2),
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.black12,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(7),
  //                                           ),
  //                                           height: 20,
  //                                           child: Center(
  //                                             child: Text(
  //                                                 cards[i]['likes'].toString() +
  //                                                     '🖤'),
  //                                           ),
  //                                         )
  //                                       ],
  //                                     ),
  //                                     Text(
  //                                       cards[i]['title'].toString(),
  //                                       maxLines: 2,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: GoogleFonts.roboto(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: 5,
  //                                 ),
  //                                 Column(
  //                                   children: [
  //                                     Divider(
  //                                       color: Colors.grey,
  //                                       height: 1,
  //                                     ),
  //                                     SizedBox(
  //                                       height: 5,
  //                                     ),
  //                                     Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(bottom: 5.0),
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Container(
  //                                             width: 90,
  //                                             child: Text(
  //                                               cards[i]['author'].toString(),
  //                                               maxLines: 1,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               style: GoogleFonts.roboto(
  //                                                 fontSize: 13,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           Container(
  //                                             width: 90,
  //                                             child: Text(
  //                                               cards[i]['duration'].toString(),
  //                                               maxLines: 1,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               style: GoogleFonts.roboto(
  //                                                 fontSize: 13,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           height: 120,
  //                           width: MediaQuery.of(context).size.width - 80,
  //                           decoration: BoxDecoration(
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 blurRadius: 10,
  //                                 spreadRadius: 4,
  //                                 color: Colors.black12,
  //                               ),
  //                             ],
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //   );
  // }
}
