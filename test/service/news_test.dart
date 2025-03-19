import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dailynews/service/news.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';
import 'package:dailynews/service/data.dart';
import 'package:dailynews/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late News newsService;

  setUp(() {
    newsService = News(); // Không mock, dùng API thật
  });

  test('TC01 - API trả về danh sách bài báo hợp lệ', () async {
    await newsService.getNews();

    // Kiểm tra danh sách có dữ liệu không
    expect(newsService.news.isNotEmpty, true);

    // Kiểm tra dữ liệu của bài báo đầu tiên
    final firstArticle = newsService.news.first;
    expect(firstArticle.title, isNotNull);
    expect(firstArticle.description, isNotNull);
    expect(firstArticle.url, isNotNull);
    expect(firstArticle.urlToImage, isNotNull);
  });

  test('TC02 - API trả về lỗi với API Key sai', () async {
    String fakeUrl =
        "https://newsapi.org/v2/everything?q=apple&apiKey=wrong_key";

    var response = await http.get(Uri.parse(fakeUrl));
    var jsonData = jsonDecode(response.body);

    expect(jsonData['status'], equals("error"));
  });

  test('TC03 - API trả về JSON không hợp lệ', () async {
    String invalidUrl = "https://newsapi.org/v2/everything?invalid_param=true";

    var response = await http.get(Uri.parse(invalidUrl));

    // Kiểm tra xem API có trả về lỗi không
    var jsonData = jsonDecode(response.body);

    expect(jsonData['status'], equals("error"));
    expect(jsonData.containsKey('message'), true);
  });

  test('TC04 - API không có bài viết phù hợp', () async {
    String noResultsUrl =
        "https://newsapi.org/v2/everything?q=unknownrandomkeyword&apiKey=f0216e15584447cf9b108d23bc07145d";

    var response = await http.get(Uri.parse(noResultsUrl));
    var jsonData = jsonDecode(response.body);

    // API trả về status = ok nhưng không có bài báo
    expect(jsonData['status'], equals("ok"));
    expect(jsonData['articles'], isEmpty);
  });
}
