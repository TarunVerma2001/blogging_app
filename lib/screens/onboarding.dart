import 'package:blogging_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blogging_app/utils/lists.dart';
import 'package:google_fonts/google_fonts.dart';



List<Map<String, String>> pageBuilder = Utils().pageBuilder;

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int pageNumber = 0;

  late PageController pageController ;

  @override
  void initState() {
    // Utils().getAllBlogs();
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (int index) {
                setState(() {
                  pageNumber = index;
                });
              },
              itemCount: pageBuilder.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        pageBuilder[i]['image'].toString(),
                        height: MediaQuery.of(context).size.height * 1.2 / 3,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          pageBuilder[i]['text'].toString(),
                          style: GoogleFonts.quicksand(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageBuilder.length,
                (index) => buildDots(index, context),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                if(pageNumber <= pageBuilder.length - 2){
                  pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                } else{
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return HomePage();
                  }));
                }
              },
              child: Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.only(bottom: 50.0, top: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Color(0xff3F3D56).withOpacity(0.1)),
                child: Center(
                  child: Container(
                    child: Center(
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 50, color: Colors.white,),
                    ),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff3F3D56)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDots(int index, BuildContext context) {
    return Container(
        height: 10,
        width: pageNumber == index ? 25 : 10,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).primaryColor,
        ));
  }
}
