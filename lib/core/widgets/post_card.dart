import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compte/core/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../screen/comments_screen.dart';
import '../services/firestore_methods.dart';
import '../utils/fonctions.dart';
import 'like_animation.dart';
import 'package:compte/core/models/user.dart' as model;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        text: err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        text: err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<UserController>(
        builder: (context) => Container(
              // boundary needed for web
              decoration: BoxDecoration(
                border: Border.all(
                  // La couleur à revoir
                  color: AppColor.blackColor,
                ),
                color: AppColor.blackColor,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
              child: Column(
                children: [
                  // HEADER SECTION OF THE POST
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            widget.snap['profImage'].toString(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.snap['username'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.snap['uid'].toString() ==
                                userController.getUser!.uid
                            ? IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    content: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          'Delete',
                                        ]
                                            .map(
                                              (e) => InkWell(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                    child: Text(e),
                                                  ),
                                                  onTap: () {
                                                    deletePost(
                                                      widget.snap['postId']
                                                          .toString(),
                                                    );
                                                    // remove the dialog box
                                                  Get.toEnd(() => null);
                                                  }),
                                            )
                                            .toList()),
                                  );
                                  
                                },
                                icon: const Icon(Icons.more_vert),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  // IMAGE SECTION OF THE POST
                  GestureDetector(
                    onDoubleTap: () {
                      FireStoreMethods().likePost(
                        likes: widget.snap['likes'],
                        postId: widget.snap['postId'].toString(),
                        uid: userController.getUser!.uid,
                      );
                      setState(() {
                        isLikeAnimating = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0)),
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: height * .35,
                          width: double.infinity,
                          child: Image.network(
                            widget.snap['postUrl'].toString(),
                            fit: BoxFit.fill,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // LIKE, COMMENT SECTION OF THE POST
                  Row(
                    children: <Widget>[
                      LikeAnimation(
                        isAnimating: widget.snap['likes']
                            .contains(userController.getUser!.uid),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes']
                                  .contains(userController.getUser!.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                          onPressed: () => FireStoreMethods().likePost(
                            likes: widget.snap['likes'],
                            postId: widget.snap['postId'].toString(),
                            uid: userController.getUser!.uid,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.comment_outlined,
                        ),
                        onPressed: () => 
                Get.to(CommentsScreen(
                      postId: widget.snap['postId'].toString(),
                    ),)
                        ,
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.send,
                          ),
                          onPressed: () {}),
                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {}),
                      ))
                    ],
                  ),
                  //DESCRIPTION AND NUMBER OF COMMENTS
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                            style:const  TextStyle(color: Colors.white),
                            
                            child: Text(
                              '${widget.snap['likes'].length} likes',
                              style: const TextStyle(color: Colors.white),
                            )),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: AppColor.backgroundColor),
                              children: [
                                TextSpan(
                                  text: widget.snap['username'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.snap['description']}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'View all $commentLen comments',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.backgroundColor,
                                ),
                              ),
                            ),
                            onTap: () => const Center(
                                  child: Text(
                                    "THis is all comment ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ) /*Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  )*/
                            ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            DateFormat.yMMMd()
                                .format(widget.snap['datePublished'].toDate()),
                            style: const TextStyle(
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
