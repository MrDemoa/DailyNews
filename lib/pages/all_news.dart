import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailynews/models/article_model.dart';
import 'package:dailynews/models/slider_model.dart';
import 'package:dailynews/pages/article_view.dart';
import 'package:dailynews/service/news.dart';
import 'package:dailynews/service/slider_data.dart';
import 'package:flutter/material.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({super.key, required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  @override
  void initState(){
    getSliders();
    getNews();
    super.initState();
  }
  getNews() async{
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {

    });
  }
  getSliders() async{
    Sliders slider = Sliders();
    await slider.getSliders();
    sliders = slider.sliders;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("${widget.news} News",
            style: const TextStyle(
                color:Colors.blue,
                fontWeight: FontWeight.bold,fontSize: 32)),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.news == "Breaking"? sliders.length: articles.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ShowAllNews(
                  Image: widget.news == "Breaking"? sliders[index].urlToImage!: articles[index].urlToImage!,
                  desc: widget.news == "Breaking"? sliders[index].description!: articles[index].description!,
                  title: widget.news == "Breaking"? sliders[index].title!: articles[index].title!,
                  url: widget.news == "Breaking"? sliders[index].url!: articles[index].url!,
                ),
              );
            }),
      ),
    );
  }
}
class ShowAllNews extends StatelessWidget {
  String Image , desc , title , url;
  ShowAllNews({super.key, required this.Image,required this.desc, required this.title,required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: Image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading effect
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.red), // Hiển thị icon lỗi
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              maxLines: 2,
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text(
              maxLines: 3,
              desc,style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}