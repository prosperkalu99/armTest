import 'package:arms_test/article_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  List<Article>? articles;

  @override
  void initState() {
    fetchArticle();
    super.initState();
  }

  fetchArticle() async {
    final response = await get(
      Uri.parse("https://newsapi.org/v2/everything?q=tesla&from=2021-08-22&sortBy=publishedAt&apiKey=4e019a951e3445c4a8a86fc32eef4489"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    if (mounted) {
      setState(() {
        articles = articlesFromJson(response.body).articles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: articles == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: List.generate(10, (index) => Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Text("${articles![index].title}", textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 14,),
                  Row(
                    children: [
                      Container(
                        height: 60, width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage("${articles![index].urlToImage}",), fit: BoxFit.cover)
                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(child: Text("${articles![index].description}", textAlign: TextAlign.justify,)),
                    ],
                  ),
                  SizedBox(height: 14,),
                  InkWell(
                    onTap: (){
                      _launch("${articles![index].url}");
                    },
                    child: Text("Link: ${articles![index].url}", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),))
                ]
              ),
            ),
          )),
        ),
      )
    );
  }

}

_launch(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Not supported");
  }
}
