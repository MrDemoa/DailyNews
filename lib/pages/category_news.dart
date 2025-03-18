import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailynews/models/show_category.dart';
import 'package:dailynews/pages/article_view.dart';
import 'package:dailynews/service/show_category_news.dart';
import 'package:flutter/material.dart';

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({super.key, required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    getNews();
  }

  getNews() async{
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCatagoryNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.name,
                style: const TextStyle(
                    color:Colors.blue,
                    fontWeight: FontWeight.bold,fontSize: 32)),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ShowCategory(
                    Image: categories[index].urlToImage!,
                  desc: categories[index].description!,
                  title: categories[index].title!,
                  url: categories[index].url!,
                ),
              );
            }),
      ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  String Image , desc , title , url;
  ShowCategory({super.key, required this.Image,required this.desc, required this.title,required this.url});

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
