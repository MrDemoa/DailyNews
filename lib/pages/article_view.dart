import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

  Future<void> summarizeArticle() async {
    String? apiKey = dotenv.env['GITHUB_TOKEN'];
    String? apiUrl = dotenv.env['AZURE_OPENAI_ENDPOINT'];
    String? modelName = dotenv.env['MODEL_NAME'];

    if (apiKey == null || apiUrl == null || modelName == null) {
      debugPrint("API Key or Endpoint is missing!");
      return;
    }

    const String completionEndpoint = "/openai/deployments/gpt-4o/chat/completions?api-version=2024-03-01-preview";

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text("Summarizing...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse("$apiUrl$completionEndpoint"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": "You are an AI that summarizes news articles concisely."},
            {"role": "user", "content": "Summarize the key points of this article briefly: ${widget.blogUrl}"}
          ],
          "temperature": 0.7,
          "max_tokens": 300,
          "model": modelName
        }),
      );

      Navigator.pop(context); // Close the loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String summary = data["choices"][0]["message"]["content"];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Article Summary",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            content: SizedBox(
              height: 400, // Set a fixed height
              child: SingleChildScrollView( // Makes it scrollable
                child: Text(summary, style: const TextStyle(fontSize: 18, height: 1.5)),
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      } else {
        debugPrint("Error: ${response.body}");
      }
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      debugPrint("Error: $e");
    }
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
      body: WebViewWidget(controller: controller),
      floatingActionButton: FloatingActionButton(
        onPressed: summarizeArticle,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.summarize, color: Colors.white),
      ),
    );
  }
}
