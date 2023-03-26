import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compte/core/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/fonctions.dart';
import 'Profil_screen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.uid});
  final String uid;
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var userData = {};
  int postLen = 0;
  List followersUid = [];
  List followers = [];
  List postLikes=[];
  bool isFollowing = false; 
  

@override
  void initState() {
    super.initState();
    getData();
  }

  getData()async {
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap= await FirebaseFirestore.instance.collection("Users").doc(widget.uid).get();
      var allUser=await FirebaseFirestore.instance.collection("Users").get();
      var allPost=await FirebaseFirestore.instance.collection("posts").get();
      followersUid=userSnap.data()!["followers"];
     
     //Collect all followers
     for (int i=0;i< allUser.docs.length;i++){
          if (followersUid.contains(allUser.docs[i]["uid"])){ 
            followers.add(allUser.docs[i]);
          }
     }

     //Collect post did you like 

     for (int i=0;i<allPost.docs.length;i++){
        if(allPost.docs[i]["likes"].contains(FirebaseAuth.instance.currentUser!.uid)){
          postLikes.add(allPost.docs[i]);
        }
        //print("alhjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"+postLikes[0]["postId"]);
     }
      setState(() {
        isLoading=false;
      });

    }catch (e) {
      showSnackBar(
        context,
         text: e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blueColor, 
        title: const Text("Notification",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30.0,)),
        
      ),
      body:isLoading?const Center(
        child: CircularProgressIndicator(),
      ):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(), 
            const Text("You likes ..",style: TextStyle(color: Colors.white),),
            const SizedBox(height: 5.0,),
            GridView.builder(
                        shrinkWrap: true,
                        itemCount: postLikes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                             postLikes[index];
                
                          return Container(
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
            
            const SizedBox(height: 25.0,),
          

          const Text("You following !!",style: TextStyle(color: Colors.white),),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: followers.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: ()=>Get.to(ProfilScreen(
                                  uid:followers[index]["uid"] ,
                                ),),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity, 
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColor.greyColor2
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15.0),
                      shape: Border.all(),
                      leading: CircleAvatar(
                        child: Image.network(followers[index]["photoUrl"]), 
                        
                      ),
                      title: Text(followers[index]["username"],style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                      subtitle: Text(followers[index]["bio"],style: const TextStyle(color: Colors.white,fontSize: 15.0),), 
                    ),
                  ),
                );
              }),
          ),
            
        ],
      ),
    );
  }
}