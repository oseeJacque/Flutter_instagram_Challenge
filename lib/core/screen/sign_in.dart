

import 'package:compte/core/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';
import '../services/auth_method.dart';
import '../utils/app_input.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey _formKey=GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  late bool isLoding; 

  @override 
  void initState(){  
    super.initState();   
     setState(() {
      isLoding = false;
    });
  } 

  @override 
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    } 
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width; 
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: AppColor.backgroudColor,
      appBar: AppBar(
        
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: width*.03), 
          width: double.infinity, 
          child: Center( 
            child: Form(
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  
                  SizedBox(height: height*.25,), 
                  
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
            
                   
                     InkWell(
                      onTap: ()async {
                        setState(() {
                          isLoding=true;
                        });
                          AuthMethods.signInpWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value){
                        if(value){
                          setState(() {
                            isLoding=false;
                          }); 
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connexion reussi")));
                        } else {
                          setState(() {
                          isLoding=false;
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur de Création de compte ")));
                         
                        });
                        }
                       });
                      },
                      child: !isLoding?Container( 
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0) 
                        ), 
                        child: const Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 15.0),), 
                      ):CircularProgressIndicator(color: AppColor.blueColor,),
                    ), 
            
                    const SizedBox(height: 16.0,),
                    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}