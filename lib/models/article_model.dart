class ArticleModel{

  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;

  ArticleModel({this.author,this.title,this.description,this.url,this.urlToImage,this.content});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json["title"],
      description: json["description"],
      url: json["url"],
      urlToImage: json["urlToImage"],
      content: json["content"],
      author: json["author"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "url": url,
      "urlToImage": urlToImage,
      "content": content,
      "author": author,
    };
  }
}