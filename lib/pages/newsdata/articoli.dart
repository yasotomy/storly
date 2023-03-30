import 'package:flutter/material.dart';
import 'newsdata.dart';
import 'storie.dart';

class AllArticlesPage extends StatefulWidget {
  final String category;
  final List<Article> articles;

  AllArticlesPage({required this.category, required this.articles});

  @override
  _AllArticlesPageState createState() => _AllArticlesPageState();
}

class _AllArticlesPageState extends State<AllArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.transparent, // Make the appBar transparent
        elevation: 0, // Remove the shadow beneath the appBar
        iconTheme: IconThemeData(
            color: Colors.black), // Set the icon color (back arrow) to black
        toolbarTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.articles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1 /
              1.25, // Aggiusta questo valore per modificare l'altezza del titolo
        ),
        itemBuilder: (context, index) {
          final article = widget.articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoriePage(article: article),
                ),
              );
              // Implementa la navigazione all'articolo selezionato o altre azioni
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  article.title,
                  style: TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
