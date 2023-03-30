import 'package:flutter/foundation.dart';
import 'newsdata.dart';

class FavoritesProvider with ChangeNotifier {
  List<Article> _favoriteArticles = [];

  List<Article> get favoriteArticles => _favoriteArticles;

  void addArticle(Article article) {
    _favoriteArticles.add(article);
    notifyListeners();
  }

  void removeArticle(Article article) {
    _favoriteArticles.removeWhere((element) => element.title == article.title);
    notifyListeners();
  }

  bool isFavorite(Article article) {
    return _favoriteArticles.any((element) => element.title == article.title);
  }
}
