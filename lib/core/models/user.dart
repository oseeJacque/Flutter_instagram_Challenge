
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String mail;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
 final List followers;
 final List following;

  const User({
    required this.mail, 
    required this.uid, 
    required this.photoUrl, 
    required this.username, 
    required this.bio, 
   required this.followers, 
   required this.following 
    }); 

  static User fromSnap( DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
  return User(
    mail: snap["email"], 
    uid: snap["uid"], 
    photoUrl: snap["photoUrl"], 
    username: snap["username"], 
    bio: snap["bio"], 
   followers:snap["followers"], 
   following:snap["following"]
    );
}


    Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": mail,
        "photoUrl": photoUrl,
        "bio": bio,
       "followers": followers,
       "following": following,
      };

static User defaultValues(){
  return const User(mail: '', uid:'', photoUrl: '', username: '', bio: '',followers:[], following: []
  );
}
}