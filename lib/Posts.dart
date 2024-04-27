//import 'dart:html';

//import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  //String id = "";
  //String content = "";
  //String authorName = "";
  //String authorProfilePicUrl = "";
  //DateTime timestamp = DateTime.now();
  //int likes = 0;
  //int comments = 0;
  //int shares = 0;
  final String userName;
  final String userImageUrl;
  final String postImageUrl;
  final String caption;
  int likeCounter;
  final String? id;

  Posts({
    this.id,
    required this.userName,
    required this.userImageUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likeCounter,
    //required this.id,
    //required this.content,
    //required this.authorName,
    //required this.authorProfilePicUrl,
    //required this.timestamp,
    //this.likes = 0,
    //this.comments = 0,
    //this.shares = 0,
  });
}
