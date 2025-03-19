import 'package:flutter_test/flutter_test.dart';
import 'package:dailynews/models/article_model.dart';

void main() {
  group("Test ArticleModel", () {
    test('TC01 - Chuyển đổi JSON thành ArticleModel', () {
      // Mock dữ liệu JSON
      final json = {
        "title": "Flutter Testing",
        "description": "Hướng dẫn kiểm thử Flutter",
        "url": "https://example.com",
        "urlToImage": "https://example.com/image.jpg",
        "content": "Nội dung bài viết",
        "author": "John Doe"
      };

      // Parse JSON thành object
      final article = ArticleModel.fromJson(json);

      // Kiểm tra dữ liệu
      expect(article.title, "Flutter Testing");
      expect(article.description, "Hướng dẫn kiểm thử Flutter");
      expect(article.url, "https://example.com");
      expect(article.urlToImage, "https://example.com/image.jpg");
      expect(article.content, "Nội dung bài viết");
      expect(article.author, "John Doe");
    });

    test('TC02 - Chuyển đổi JSON với giá trị null', () {
      // JSON có một số giá trị null
      final json = {
        "title": null,
        "description": "Bài báo không có tiêu đề",
        "url": "https://example.com",
        "urlToImage": null,
        "content": null,
        "author": "Unknown"
      };

      // Parse JSON thành object
      final article = ArticleModel.fromJson(json);

      // Kiểm tra dữ liệu
      expect(article.title, isNull);
      expect(article.description, "Bài báo không có tiêu đề");
      expect(article.url, "https://example.com");
      expect(article.urlToImage, isNull);
      expect(article.content, isNull);
      expect(article.author, "Unknown");
    });

    test('TC03 - Chuyển đổi ArticleModel thành JSON', () {
      // Tạo object ArticleModel
      final article = ArticleModel(
          title: "Test JSON",
          description: "Chuyển đổi ArticleModel sang JSON",
          url: "https://example.com",
          urlToImage: "https://example.com/image.jpg",
          content: "Nội dung JSON test",
          author: "Tester"
      );

      // Convert thành JSON
      final json = article.toJson();

      // Kiểm tra dữ liệu JSON
      expect(json["title"], "Test JSON");
      expect(json["description"], "Chuyển đổi ArticleModel sang JSON");
      expect(json["url"], "https://example.com");
      expect(json["urlToImage"], "https://example.com/image.jpg");
      expect(json["content"], "Nội dung JSON test");
      expect(json["author"], "Tester");
    });
  });
}
