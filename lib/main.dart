import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/colors.dart';
import 'core/screen/sign_in.dart';
import 'core/screen/sign_up.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized(); 
await Firebase.initializeApp();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:  ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColor.mobileBackgroundColor,
        ),
      home:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          print(snapshot.data);
          if(!snapshot.hasData){
            return  const SignUp() ;
          }
          return const SignIn();
        }),
    );
  }
}

