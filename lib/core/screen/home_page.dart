
import 'package:compte/core/controller/userController.dart';
import 'package:compte/core/screen/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import 'Profil_screen.dart';
import 'add_post_screen.dart';
import 'feed_scren.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

UserController userController=Get.put(UserController());
  List<Widget>mobilePage= [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  NotificationPage(uid: FirebaseAuth.instance.currentUser!.uid.toString(),),
   ProfilScreen(uid: FirebaseAuth.instance.currentUser!.uid.toString(),),
    ];
  PageController controller=PageController();
  late int _page;

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    _page=0;
  }


  @override 
  void dispose(){
    super.dispose(); 
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:PageView(
        controller:controller,
        onPageChanged: onPageChange,
        physics: const NeverScrollableScrollPhysics(),
        children:mobilePage,
      ),
      bottomNavigationBar: CupertinoTabBar(
      onTap: navigationTapped,
      currentIndex: _page,
      items:[
        //Home

        BottomNavigationBarItem(icon: Icon(Icons.home,
        color:_page==0?AppColor.blueColor:AppColor.greyColor ,), 
        label: '', 
        
        
        ),

        //Search
        BottomNavigationBarItem(icon: Icon(Icons.search,
        color:_page==1?AppColor.blueColor:AppColor.greyColor ,
        ), 
        label: '',        ),

        //
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, 
        color:_page==2?AppColor.blueColor:AppColor.greyColor ,), 
        label: '',
        
        ),

        //
        BottomNavigationBarItem(icon: Icon(Icons.favorite, 
        color:_page==3?AppColor.blueColor:AppColor.greyColor ,), 
        label: '',        ),

        //
        BottomNavigationBarItem(icon: Icon(Icons.person, 
        color:_page==4?AppColor.blueColor:AppColor.greyColor ,), 
        label: '',        ),
        
      ]),
    );
  }

  //Utils fonctions 
  void onPageChange(int page) {
    setState(() {
      _page=page;
    });
  }
  void navigationTapped(int page) {
    //Animating Page
    controller.jumpToPage(page);
  }
}
