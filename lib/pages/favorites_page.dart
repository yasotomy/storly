import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'newsdata/favorites_provider.dart';

import 'newsdata/newsdata.dart';
import 'newsdata/storie.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        List<Article> favoriteArticles = favoritesProvider.favoriteArticles;
        return Scaffold(
          appBar: AppBar(
            title: Text("Libreria"),
            backgroundColor: Colors.transparent, // Make the appBar transparent
            elevation: 0, // Remove the shadow beneath the appBar
            iconTheme: IconThemeData(
                color:
                    Colors.black), // Set the icon color (back arrow) to black
            toolbarTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          body: ListView.builder(
            itemCount: favoriteArticles.length,
            itemBuilder: (context, index) {
              final article = favoriteArticles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Adjust the padding as needed
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        article.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(article.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoriePage(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
