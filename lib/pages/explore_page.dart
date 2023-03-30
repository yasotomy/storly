import 'package:flutter/material.dart';
import 'newsdata/newsdata.dart';
import 'newsdata/storie.dart';
import 'newsdata/articoli.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  late Future<List<Article>> _futureArticles;
  late Future<List<String>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureArticles = NewsData().fetchNews();
    _futureCategories = NewsData().fetchCategories();
  }

  void _searchArticles(String query) {
    setState(() {
      _searchQuery = query;
      _futureArticles = NewsData().searchArticles(query);
    });
  }

  Widget _buildCategoryGrid(List<String> categories) {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () async {
            List<Article> articlesByCategory =
                await NewsData().fetchNewsByCategory(category);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllArticlesPage(
                  category: category,
                  articles: articlesByCategory,
                ),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TextField(
                onChanged: (value) {
                  _searchArticles(value);
                },
                decoration: InputDecoration(
                  hintText: "Cerca...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ),
        ),
      ),
      body: _searchQuery.isEmpty
          ? FutureBuilder<List<String>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                } else {
                  List<String> categories = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildCategoryGrid(categories),
                  );
                }
              },
            )
          : FutureBuilder<List<Article>>(
              future: _futureArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                } else {
                  List<Article> articles = snapshot.data!;
                  if (articles.isEmpty) {
                    return Center(child: Text('Nessun risultato trovato.'));
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoriePage(
                                    article: article,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              margin: EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        article.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    article.title,
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
      resizeToAvoidBottomInset: false,
    );
  }
}
