import 'dart:convert';

import 'package:dailynews/models/slider_model.dart';
import 'package:http/http.dart' as http;
class Sliders{
  List<SliderModel> sliders = [];

  Future<void> getSliders() async{
    String url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=f0216e15584447cf9b108d23bc07145d";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"]!=null && element['description']!=null ){
          SliderModel sliderModel = SliderModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
              author: element["author"]
          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}