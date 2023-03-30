import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'newsdata/newsdata.dart';
import 'newsdata/storie.dart';
import 'newsdata/articoli.dart';

class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> _futureNewsData;
  late String _greeting;

  @override
  void initState() {
    super.initState();
    _futureNewsData = NewsData().fetchNews();
    _setGreeting();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Buongiorno!';
    } else if (hour < 18) {
      _greeting = 'Buon pomeriggio!';
    } else {
      _greeting = 'Buona sera!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 40.0),
              child: Container(
                child: Text(
                  _greeting,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _futureNewsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  } else {
                    Map<String, List<Article>> articlesByCategory = {};
                    for (final article in snapshot.data!) {
                      if (articlesByCategory.containsKey(article.category)) {
                        articlesByCategory[article.category]!.add(article);
                      } else {
                        articlesByCategory[article.category] = [article];
                      }
                    }

                    List<String> categories = articlesByCategory.keys.toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: categories
                            .map((category) => _buildArticleListView(category,
                                articlesByCategory[category] ?? <Article>[]))
                            .toList(),
                      ),
                    );
                  }
                },
              ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.toString(),
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllArticlesPage(
                        category: category,
                        articles: articles,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Vedi tutto',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Color.fromARGB(255, 122, 119, 119),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.35,
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
                  width: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: NetworkImage(article.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
