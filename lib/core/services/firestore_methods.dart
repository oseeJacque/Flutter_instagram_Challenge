import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compte/core/services/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Enregistrer un post
  Future<bool> uploadPost({
    required String description,
    required Uint8List file,
    required String username,
    required String profilImage,
  }) async {
    try {
      String photUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = Uuid().v1();

      Post post = Post(
          description: description,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photUrl,
          profImage: profilImage);

      _firestore.collection("posts").doc(postId).set(post.toJson());
      print("Post en registré avec succès "); 
      return true;
    } catch (err) {
      print(err.toString());
    }
    return false;
  }

  //Aimer un post 
  Future <String> likePost({
    required String postId, 
    required String uid,
    required List likes
  })async{
    String res="Une erreur est suvenue "; 
    try {
      if (likes.contains(uid)){
        // Suppressionde l'identifiant de l'utilisateur qui a aimé le Post 
        _firestore.collection("posts").doc(postId).update({'likes':FieldValue.arrayRemove([uid])});
      }else{
        // Ajout de l'identifiant de liutilistateur qui a liker le post 
        _firestore.collection("posts").doc(postId).update({'likes':FieldValue.arrayUnion([uid])});

      }
      res="success";
    }catch(err){
      res=err.toString();
      print(err.toString());
    }
    return res;
  }  

  //Commenter un Post  

  Future <String> postComment({
    required String postId,
    required String text, 
    required String userUid, 
    required String username, 
    required String userProfilPic
  })async{
    String res="Une erreur est survenu "; 
    try{
      if(text.isNotEmpty){
        //L'identifiant du commentaire  
        String commentId=const Uuid().v1();

        //enregistrement du commentaire  
        _firestore .collection("posts").doc(postId).collection("comments").doc(commentId).set({
          'profilePic': userProfilPic,
          'name': username,
          'uid': userUid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res="success";
      }else {
        res="Please enter text";
      }
    }catch(err){
      res=err.toString(); 
    } 
    return res;
  }

  // Suprimer un post 
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  } 

Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

}
