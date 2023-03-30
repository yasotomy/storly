import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class NewsData {
  static const String _baseUrl = 'https://isolable-crystal.000webhostapp.com/';

  Future<List<Article>> fetchNews() async {
    final response = await http.get(Uri.parse(_baseUrl + 'storie.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Article> articles = jsonResponse
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<Article>> fetchNewsByCategory(String category) async {
    final allArticles = await fetchNews();
    List<Article> articlesByCategory =
        allArticles.where((article) => article.category == category).toList();
    return articlesByCategory;
  }

  Future<List<Article>> searchArticles(String query) async {
    final allArticles = await fetchNews();
    List<Article> filteredArticles = allArticles
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredArticles;
  }

  Future<List<String>> fetchCategories() async {
    final allArticles = await fetchNews();
    List<String> allCategories =
        allArticles.map((article) => article.category).toSet().toList();
    return allCategories;
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String category;

  Article(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.category});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['urlToImage'],
      category: json['category'],
    );
  }
}

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;

  CustomCachedNetworkImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Center(child: Text('Error loading image')),
    );
  }
}
