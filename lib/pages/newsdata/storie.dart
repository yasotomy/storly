import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'newsdata.dart';
import 'favorites_provider.dart';

class StoriePage extends StatefulWidget {
  final Article article;

  StoriePage({required this.article});

  @override
  _StoriePageState createState() => _StoriePageState();
}

class _StoriePageState extends State<StoriePage> {
  late Future<List<Article>> _futureRelatedNewsData;

  @override
  void initState() {
    super.initState();
    _futureRelatedNewsData =
        NewsData().fetchNewsByCategory(widget.article.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              bool isFavorite = favoritesProvider.isFavorite(widget.article);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoritesProvider.removeArticle(widget.article);
                    } else {
                      favoritesProvider.addArticle(widget.article);
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.article.imageUrl.isNotEmpty)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.article.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              widget.article.title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              widget.article.description,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<Article>>(
              future: _futureRelatedNewsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                } else {
                  return _buildArticleListView(
                    widget.article.category,
                    snapshot.data!,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleListView(String category, List<Article> articles) {
    final firstEightArticles = articles.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 16.0, right: 12.0),
          child: Text(
            category.toString(),
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: MediaQuery.of(context).size.width * 0.33,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: firstEightArticles.length,
            itemBuilder: (context, index) {
              final article = firstEightArticles[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoriePage(article: article),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        article.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
