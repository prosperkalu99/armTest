import 'dart:html';

import 'package:arms_test/constants.dart';
import 'package:arms_test/create_edit_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Helpers/flush_bar_helper.dart';
import 'Helpers/progres_dialog_helper.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance.collection('posts').snapshots();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> delete(String id) async {
    ProgressDialogHelper().showProgressDialog(context, "Please wait...");
    posts.doc(id).delete()
        .then((value) {
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar("Post successfully deleted", color: Colors.green);
    }).catchError((error) {
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar("Opps! Something went wrong, please retry", color: Colors.red);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _postsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Oops! Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            physics: BouncingScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Container(
                child: Column(
                  children: [
                    Text(data['title'],),
                    Text(data['description'],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: (){
                            delete(document.id);
                          },
                          child: Icon(Icons.delete),),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> CreateEditPost(editPost: true, docID: document.id,)));
                          },
                          child: Icon(Icons.edit),),
                      ],
                    )
                  ],
                ),
              );}).toList(),
          );
        },
      ),
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateEditPost()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kPrimaryColor
          ),
          child: Row(mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white,),
              SizedBox(width: 2,),
              Text("ADD NEW POST", style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }
}
