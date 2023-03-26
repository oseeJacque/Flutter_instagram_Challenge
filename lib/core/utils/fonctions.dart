import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// for picking up image from gallery
Future pickImage(ImageSource source) async {
  final image=await ImagePicker().pickImage(source: source);
  if (image != null) {
    return await image.readAsBytes();
  }
  print('No Image Selected');
}

showSnackBar(BuildContext context,{required String text}){
return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}