
import 'dart:convert';

import 'package:dailynews/models/article_model.dart';
import 'package:http/http.dart' as http;
class News{
  List<ArticleModel> news = [];

  Future<void> getNews() async{
    String url="https://newsapi.org/v2/everything?q=apple&from=2025-03-14&to=2025-03-14&sortBy=popularity&apiKey=f0216e15584447cf9b108d23bc07145d";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"]!=null && element['description']!=null ){
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"]
          );
          news.add(articleModel);
        }
      });
    }
  }
}