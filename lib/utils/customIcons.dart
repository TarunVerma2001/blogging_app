import 'package:flutter/material.dart';
Center menu(double size) {
  return Center(
    child: Container(
      height: size,
      width: size,
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
               dot(size, Colors.black12),
               SizedBox(width: size * 1.5 / 5,),
               dot(size, Colors.black),
              ],
            ),
            SizedBox(height: size * 1.5 / 5,),
            Row(
              children: [
               dot(size, Colors.black),
               SizedBox(width: size * 1.5 / 5,),
               dot(size, Colors.black12),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Container dot(double size, Color color) {
  return Container(
    width: size/5,
    height: size/5,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
  );
}
