import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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
      'data/user/0/com.example.blogging_app/cache/image_picker5847146402291347659.jpg');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1B262C),
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
                pageTitle(),
                SizedBox(height: 20),
                blogTitle(),
                SizedBox(height: 20),
                blogTag(),
                SizedBox(height: 20),
                blogDiscription(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Image',
                    style: GoogleFonts.roboto(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffBBE1FA)),
                  ),
                ),
                SizedBox(height: 20),
                imagePicker(),
                SizedBox(
                  height: 20,
                ),
                if (imageFile != null) ...[
                  Image.file(
                    File(imageFile.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ],
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.black12,
                    color: Color(0xff0F4C75),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      splashColor: Color(0xffBBE1FA),
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

                        var imageUrl;
                        //upload image
                        try {
                          var res =
                              await ApiServices().uploadImage(imageFile.path);
                          var jsonResponse = json.decode(res.toString());
                          imageUrl = jsonResponse['url'];
                          print(imageUrl);
                        } on DioError catch (e) {
                          // var snackBar = SnackBar(
                          //     content: Text(e.response!.data['message']),
                          //     duration: Duration(milliseconds: 2500));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        try {
                          var response = await ApiServices().createBlog(
                            titleController.text,
                            descriptionController.text,
                            tagController.text,
                            imageUrl,
                          );
                          var responseJson = json.decode(response.toString());
                          print(responseJson);
                        } on DioError catch (e) {
                          var snackBar = SnackBar(
                              content: Text(e.response!.data['message']),
                              duration: Duration(milliseconds: 2500));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomePage()),
                            (Route<dynamic> route) => false);
                      },
                      child: createButton(),
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

  Container createButton() {
    return Container(
      height: 100,
      width: double.infinity,
      child: Center(
        child: Text(
          'Create',
          style: GoogleFonts.roboto(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Color(0xffBBE1FA)),
        ),
      ),
    );
  }

  Padding imagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        elevation: 10,
        shadowColor: Colors.black12,
        color: Color(0xff3282B8),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            pickImage();
          },
          splashColor: Color(0xffBBE1FA),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 10,
                //     spreadRadius: 2,
                //     color: Colors.black12,
                //   )
                // ],
              ),
              height: 40,
              width: double.infinity,
              child: Center(
                  child: Text(
                'Pick image',
                style:
                    GoogleFonts.roboto(color: Color(0xff1B262C), fontSize: 20),
              ))),
        ),
      ),
    );
  }

  Padding blogDiscription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
          height: 500,
          child: textField(
              label: 'Discription', controller: descriptionController)),
    );
  }

  Padding blogTag() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
          height: 70,
          child: textField(label: 'Tag', controller: tagController)),
    );
  }

  Padding blogTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
          height: 70,
          child: textField(label: 'Title', controller: titleController)),
    );
  }

  Padding pageTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Text(
          'Create Blog',
          style: GoogleFonts.roboto(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: Color(0xffBBE1FA)),
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
      cursorColor: Color(0xffBBE1FA),
      style: GoogleFonts.quicksand(color: Color(0xffBBE1FA)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.quicksand(color: Color(0xffBBE1FA)),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Color(0xffBBE1FA),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Color(0xff0F4C75),
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
            color: Color(0xffBBE1FA).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
