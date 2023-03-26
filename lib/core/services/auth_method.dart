
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compte/core/services/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:compte/core/models/user.dart' as model;
import 'package:flutter/foundation.dart';

class AuthMethods{
  static final FirebaseAuth _auth=FirebaseAuth.instance; 
  static final FirebaseFirestore _firestore=FirebaseFirestore.instance; 

static Future<model.User> getUserDetails() async { 
  User currentUser = _auth.currentUser!;
  DocumentSnapshot snap =
      await _firestore.collection("Users").doc(currentUser.uid).get();
      return model.User.fromSnap(snap); // renvoie une valeur par défaut

}


  /// Sign up fonction 
  static Future <bool> signUpWithEmailAndPassword(
    {
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? photo,
    }
  )async{
    try{

       UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, 
            password: password); 

            //Enregistrement d'image dans la base de données 
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', photo!, false);
       
        //Enregistrement dans la base de donnée
        print("Add User to data baseAdd User to data baseAdd User to data baseAdd User to data base");

         model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          bio: bio,
          mail: email,
          followers: [] , 
          following: []  
        ); 
        final resultat =await _firestore.collection("Users").doc(cred.user!.uid).set(user.toJson());
        if (kDebugMode) {
          print("Enregistrement non éffectué "); 
        }
        if(cred.user!.uid.isNotEmpty){
          return true;
        }
        return false;
    }catch(err){
      print(err.toString()); 
      return false;
    } 

  } 

static Future <bool> signInpWithEmailAndPassword({
  required String email, 
  required String password,
})async{
  try{
 UserCredential cred=await _auth.signInWithEmailAndPassword(email: email, password: password);
 if (cred.user!.uid.isNotEmpty){
  return true;
 }
 return false;
}catch(er){
  print(er.toString());
  return false;
}
  }
static signOut(){
  FirebaseAuth.instance.signOut();
}
 
}