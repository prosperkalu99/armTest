import 'package:arms_test/news.dart';
import 'package:arms_test/posts.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Center(child: Text("Arms Pension Test", style: TextStyle(color: Colors.white),)), elevation: 0, automaticallyImplyLeading: false,),
      body: NewsPosts(),
    );
  }
}

class NewsPosts extends StatefulWidget {
  const NewsPosts({Key? key}) : super(key: key);

  @override
  _NewsPostsState createState() => _NewsPostsState();
}

class _NewsPostsState extends State<NewsPosts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, child: Scaffold(
        appBar : TabBar(labelColor: kPrimaryColor, labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black, unselectedLabelStyle: TextStyle(fontSize: 18, ),
            indicatorColor: kPrimaryColor, physics: BouncingScrollPhysics(),
            tabs : [
              Tab(text: "POSTS",),
              Tab(text: "NEWS",),
            ]
        ),
        body : TabBarView(
            physics: BouncingScrollPhysics(),
            children : [
              Posts(),
              News(),
            ]
        )
    ),
    );
  }
}

