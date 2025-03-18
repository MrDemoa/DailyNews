
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dailynews/models/article_model.dart';
import 'package:dailynews/models/category_model.dart';
import 'package:dailynews/models/slider_model.dart';
import 'package:dailynews/pages/all_news.dart';
import 'package:dailynews/pages/article_view.dart';
import 'package:dailynews/pages/category_news.dart';
import 'package:dailynews/service/data.dart';
import 'package:dailynews/service/news.dart';
import 'package:dailynews/service/slider_data.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  int activeIndex = 0;
  @override
  void initState(){
    categories = getCategories();
    getSliders();
    getNews();
      super.initState();
  }

  getNews() async{
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }
  getSliders() async{
    Sliders slider = Sliders();
    await slider.getSliders();
    sliders = slider.sliders;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Daily",style: TextStyle(fontSize: 32),),
            Text("News",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 32))],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading? const Center(child: CircularProgressIndicator()): SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,itemBuilder: (context,index){
              return CategoryTile(
                image: categories[index].image,
                categoryName: categories[index].categoryName,);
            }
            ),
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Breaking News!",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Breaking")));
                    },
                    child: const Text("View All",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 30,),
              CarouselSlider.builder(
                itemCount: sliders.isEmpty ? 1 : sliders.length,
                itemBuilder: (context, index, realIndex) {
                  if (sliders.isEmpty) {
                    return buildImage('default_image_url', index, 'No data available', '', context);
                  }
                  String imageUrl = sliders[index].urlToImage ?? 'default_image_url';
                  String title = sliders[index].title ?? 'No Title Available';
                  String url = sliders[index].url ?? ''; // Ensure URL is passed
                  return buildImage(imageUrl, index, title, url, context);
                },
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
              ),
            const SizedBox(height: 30,),
            Center(child: buildIndicator()),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Trending News!",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Trending")));
                      },
                      child: const Text("View All",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: BlogTile(
                            url: articles[index].url ?? '',
                              imageUrl: articles[index].urlToImage ?? '',
                              title: articles[index].title ?? 'No Title',
                              desc: articles[index].description ?? 'No Description'),
                        );
                  }),
                ),
          ],
          )
        ),
      ),
    );
  }
  Widget buildImage(String image, int index, String name, String url, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(blogUrl: url),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 200,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading effect
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.red), // Error icon
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(top: 140),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() {
    int safeCount = (sliders.isNotEmpty) ? sliders.length : 1;
    int safeActiveIndex = (activeIndex >= 0 && activeIndex < safeCount) ? activeIndex : 0;

    return SizedBox(
      height: 20, // Ensures a finite height
      child: AnimatedSmoothIndicator(
        activeIndex: safeActiveIndex,
        count: safeCount,
        effect: const ScrollingDotsEffect(dotWidth: 15, dotHeight: 15),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final image , categoryName;
  const CategoryTile({super.key, this.categoryName,this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              image,
              width: 120,
              height: 80,
            fit: BoxFit.cover,)
            ,),
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black26,),
            child: Center(
              child:
                Text(categoryName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
            )
          )
          ],),
      ),
    );
  }
}
class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc,url;
  BlogTile({super.key, required this.imageUrl,required this.title,required this.desc,required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url,)));
      },
      child:

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
          elevation: 3.5,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                        CachedNetworkImage(
                          imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading effect
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.red), // Hiển thị icon lỗi
                        )
                    )),
                const SizedBox(width: 8.0,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2.2,
                      child: Text(title.isNotEmpty ? title : "No Title",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                        maxLines: 2, // Giới hạn số dòng hiển thị
                        overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu văn bản quá dài
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2.2,
                      child: Text(desc.isNotEmpty ? desc : "No Description Available",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                  ],
                ), const SizedBox(height: 10.0),
              ],),
          ),
        ),

      ),
    );

  }
}

