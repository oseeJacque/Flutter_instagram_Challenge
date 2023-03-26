import 'dart:typed_data';

import 'package:compte/core/constants/colors.dart';
import 'package:compte/core/controller/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firestore_methods.dart';
import '../utils/fonctions.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  UserController user = Get.put(UserController());

//Sélectionner une image à partir de different sources
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

//Poster
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      bool res = await FireStoreMethods().uploadPost(
        description: _descriptionController.text,
        file: _file!,
        profilImage: profImage,
        username: username,
      );
      if (res) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(
          context,
          text: 'Posted!',
        );
        clearImage();
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(
          context,
          text: "Une erreur est survenue",
        );
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        text: err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
      _descriptionController.text="";
    });
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(padding: EdgeInsets.only(top: 0.0)),
                    const Divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       /* GetBuilder<UserController>(
                          builder: (context)=>Text(
                            user.getUser!.username,style: const TextStyle(color: Colors.white),)),*/
            
                        const Center(child: Text("New Post",style: TextStyle(color: Colors.white,fontSize: 25.0,fontWeight: FontWeight.bold),)),
                        const SizedBox(height: 30.0,),
                        const Text("Caption",style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: "Write a caption...",
                                border: InputBorder.none),
                            maxLines: 5,
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 450 / 420,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColor.blueColor, 
                                  spreadRadius: 1.0,
                                  blurRadius: 10.0, 
                                  offset: Offset(1,3)
                                )
                              ],
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            )),
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                         Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.blueColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: GetBuilder<UserController>(
                              builder: (context)=>TextButton(
                              onPressed: () => postImage(
                                user.getUser!.uid,
                                user.getUser!.username,
                                user.getUser!.photoUrl,
                              ),
                              child: const Text(
                                "Post",
                                style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),)
                            )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
