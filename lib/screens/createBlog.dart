import 'dart:convert';
import 'dart:io';
import 'package:blogging_app/screens/home_page.dart';
import 'package:blogging_app/services/apiServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  File imageFile = File(
      '/data/user/0/com.example.blogging_app/cache/image_picker2079252149172990567.jpg');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: appBar(),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Text(
                      'Create Blog',
                      style: GoogleFonts.roboto(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                      height: 70,
                      child: textField(
                          label: 'Title', controller: titleController)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                      height: 70,
                      child:
                          textField(label: 'Tag', controller: tagController)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                      height: 500,
                      child: textField(
                          label: 'Discription',
                          controller: descriptionController)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Image',
                    style: GoogleFonts.roboto(
                        fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Text('pick image'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (imageFile != null) ...[
                  Image.file(
                    File(imageFile.path),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    width: double.infinity,
                  ),
                ],
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();

                    var token = sharedPreferences.getString('token');

                    if (token == null) {
                      var snackBar = SnackBar(
                          content: Text('Please Log In to Create a Blog!'),
                          duration: Duration(milliseconds: 1500));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    var response = await ApiServices().createBlog(
                      titleController.text,
                      descriptionController.text,
                      tagController.text,
                    );
                    var responseJson = json.decode(response.toString());
                    print(responseJson);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: new LinearGradient(
                              colors: [
                                Colors.black38.withOpacity(0.7),
                                Color(0xff191720)
                              ],
                              stops: [
                                0.0,
                                0.5
                              ],
                              begin: FractionalOffset.topRight,
                              end: FractionalOffset.bottomLeft,
                              tileMode: TileMode.repeated)),
                      child: Center(
                        child: Text(
                          'Create',
                          style: GoogleFonts.roboto(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    XFile? selected =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(selected!.path);
      print(imageFile.path);
    });
  }

  TextFormField textField(
      {required String label, required TextEditingController controller}) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      toolbarOptions:
          ToolbarOptions(selectAll: true, copy: true, paste: true, cut: true),
      maxLines: null,
      minLines: null,
      expands: true,
      controller: controller,
      style: GoogleFonts.quicksand(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.quicksand(color: Colors.black),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Colors.blue,
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
            color: Color(0xff200E32).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
