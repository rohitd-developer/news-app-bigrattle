import 'package:bloc/bloc.dart';
import 'package:newsapp/api/news_repository.dart';
import 'package:newsapp/bloc/news_event.dart';
import 'package:newsapp/bloc/news_state.dart';
import 'package:newsapp/model/news.dart';

class NewsBloc extends Bloc<NewsEvent,NewsState>{
  final NewsRepository repository;
  List<Articles> bookmarkList= List<Articles>();
  News news=News();

  NewsBloc(this.repository) : super(NewsInitial());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event)  async*{


    if(event is FetchNews){

      yield NewsLoading();
      try{

         news = await repository.getTopNewsHeadLines();
         if(news==null)
           {
             yield NewsError('Api Problem');
           }
        yield NewsLoaded(news);

      }catch(e){
        yield NewsError(e.toString());
      }
    }
     if(event is SearchNews){
      try{
         news = await repository.getNewsSearchResult(event.searchText);
         if(news==null)
           {
             yield NewsError('Api Problem');
           }
        yield NewsSearch(news);
      }
      catch(e){
        yield NewsError(e.toString());

      }
    }
     if(event is BookmarkNews){
       bookmarkList.add(event.article);
       yield NewsLoaded(news);


     }
     if(event is ShowBookmark)
       {
         if(bookmarkList.isNotEmpty)
         {
        final bookmarks = news;
        bookmarks.articles = bookmarkList;
        yield NewsBookmarkList(bookmarks);
      }
         else{
           yield NoBookmarks();
         }
    }
     if(event is RemoveBookmark)
       {
         bookmarkList.remove(event.articles);
         final bookmarks = news;
        if(bookmarkList.isNotEmpty) {
        bookmarks.articles = bookmarkList;
        yield NewsBookmarkList(bookmarks);
      }
        else{
          yield NoBookmarks();
        }
    }



  }

}