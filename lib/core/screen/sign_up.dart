
import 'package:compte/core/screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';
import '../services/auth_method.dart';
import '../utils/app_input.dart';
import '../utils/fonctions.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> { 
  GlobalKey _formKey=GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image; 

  late bool isLoding; 

  @override 
  void initState(){  
    super.initState();   
     setState(() {
      isLoding = false;
      _image=null;
    });
  } 

  @override 
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  } 


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width; 
    double height=MediaQuery.of(context).size.height;

    return Scaffold( 
      //backgroundColor: AppColor.backgroudColor,
      body: SingleChildScrollView( 
        child: SafeArea(
          top: true,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: width*.03), 
            width: double.infinity, 
            child: Center( 
              child: Form(
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    //Image intagram
                    SvgPicture.asset( 
                      "assets/images/instagramme.svg",
                      color: Colors.white,
                    ),
                        const SizedBox(
                      height: 14.0,
                    ),
                    //Circular widget to accept and show  selected file
                    
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    AssetImage("assets/images/pers-removebg-preview.png")
                              ),
                        Positioned(
                            bottom: -10,
                            left: 80.0,
                            child: IconButton(
                                //add photo button
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo)))
                      ],
                    ),
                    
                    SizedBox(height: height*.05,), 
                    //  Enter your username
                      AppFieldInput(
                          textEditingController: _usernameController,
                          hintText: "Enter your username",
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 24.0,
                      ),
                      
                      //  Enter your mail
                      AppFieldInput(
                          textEditingController: _emailController,
                          hintText:"Enter your email",
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 24.0,
                      ),
                      //  Enter your password
                      AppFieldInput(
                          isPass: true,
                          textEditingController: _passwordController,
                          hintText: "Write your password",
                          textInputType: TextInputType.text),
                      
                      const SizedBox(
                        height: 24.0,
                      ),
              
                      //  Enter your bio
                      AppFieldInput(
                          textEditingController: _bioController,
                          hintText: "What did you do ?",
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 24.0,
                      ),
              
                      const SizedBox(height: 16.0,), 
                      InkWell(
                        onTap: (){
                          setState(() {
                            isLoding=true;
                          });
                         AuthMethods.signUpWithEmailAndPassword(email: _emailController.text, password: _passwordController.text, username: _usernameController.text, bio: _bioController.text, photo:_image).then((value){
                          if(value){
                            setState(() {
                              isLoding=false;
                            }); 
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn()));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Création de compte réussi avec succès",style: TextStyle(color: Colors.white),),backgroundColor: Colors.grey,));
                          } else {
                            setState(() {
                            isLoding=false;
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur de Création de compte ")));
                           
                          });
                          }
                         });
                        },
                        child: Container( 
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0) 
                          ), 
                          child: const Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 15.0),), 
                        ),
                      ),
                      !isLoding? Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                        child: InkWell( 
                          onTap: (){
                            Get.to(SignIn());
                          },
                          child: const Text("Sign in !",style: TextStyle(color: Colors.blue),),
                        ),
                        ),
                      ):const Center(child: CircularProgressIndicator(),), 
              
                      const SizedBox(height: 16.0,),
                      Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){},
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0), 
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                child: Image.asset("assets/images/google-removebg-preview.png"),
                              ),
                            ),
                          ), 
              
                          InkWell(
                            onTap: (){},
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0), 
                                color: Colors.white,
                              ),
                              child: Image.asset("assets/images/facebook.png"),
              
                            ),
                          ), 
                         
                        ],
                      ), 
                      SizedBox(height: height*.1,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

   void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }
}