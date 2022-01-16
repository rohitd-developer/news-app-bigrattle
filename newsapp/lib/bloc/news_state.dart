
import 'package:flutter/cupertino.dart';
import 'package:newsapp/model/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState{}

class NewsLoading extends NewsState{}

class NewsLoaded extends NewsState{

  final News news;
  NewsLoaded(this.news);
}


class NewsSearch extends NewsState{
  final News news;
  NewsSearch(this.news);

}

class NewsError extends NewsState{
  final String message;
  NewsError(this.message);

}

class NewsValue extends NewsState{
  final String value;

  NewsValue(this.value);
}

class BookmarkDone extends NewsState{

}

class NoBookmarks extends NewsState{

}

class NewsBookmarkList extends NewsState{

  final News news;
  NewsBookmarkList(this.news);
}
