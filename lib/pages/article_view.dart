import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  String blogUrl;
  ArticleView({super.key, required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController() ..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(widget.blogUrl));
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: WebViewWidget(controller: controller,
        )
    ),
    );
  }
}
