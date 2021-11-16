import 'package:image_picker/image_picker.dart';


// class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
//   @override
//   Future<String> pickImage(ImageSource source) async {
//     final file = await ImagePicker.pickImage(source: source);
//     if (file == null) return null;
//     // We simply return the absolute path to selected file.
//     return file.uri.toString();
//   }
// }