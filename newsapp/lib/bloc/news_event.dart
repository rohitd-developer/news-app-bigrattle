


import 'package:newsapp/model/news.dart';

abstract class NewsEvent{}

class FetchNews extends NewsEvent{

}

class SearchNews extends NewsEvent{
  final String searchText;
  SearchNews(this.searchText);

}

class BookmarkNews extends NewsEvent{
  final Articles article;
  BookmarkNews(this.article);

}

class RemoveBookmark extends NewsEvent{
  final Articles articles;
  RemoveBookmark(this.articles);
}

class ShowBookmark extends NewsEvent{

}