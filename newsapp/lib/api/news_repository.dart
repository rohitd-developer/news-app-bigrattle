import 'dart:convert';

import 'package:http/http.dart';
import 'package:newsapp/model/news.dart';



abstract class NewsRepository{
  Future<News> getTopNewsHeadLines();
  Future<News> getNewsSearchResult(String searchText);
}

class NewsRepositoryImplementation extends NewsRepository{

  @override
  Future<News> getTopNewsHeadLines() async{

    try{

      Response response = await get('https://gnews.io/api/v4/top-headlines?token=3d9b7a12f90f74a026bbbcaac03b29e8&lang=en&max=20');

      print(response.body);
      if(response.statusCode==200){
        final data = jsonDecode(response.body);

        return News.fromJson(data);
      }
      else{
        throw Exception('Problem Occured');
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Future<News> getNewsSearchResult(String searchText) async{

    try{

      Response response = await get('https://gnews.io/api/v4/search?q=$searchText&token=3d9b7a12f90f74a026bbbcaac03b29e8&lang=en&max=20');

      print(response.body);
      if(response.statusCode==200) {
        final data = jsonDecode(response.body);

        return News.fromJson(data);
      }
      else{
        throw Exception('Problem Occured');
      }
    }catch(e){
      print(e);

    }
  }
}