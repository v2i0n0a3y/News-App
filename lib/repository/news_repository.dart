import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newzzindia/model/categories_news_model.dart';
import 'package:newzzindia/model/news_chanel_headlines_model.dart';

class NewsRepository{

  Future<NewsChanelHeadlinesModel> fetchNewChanelHeadLineApi(String channelName)async{

    String url = "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=33cb32e8dc8a4d97bdad3b0ef32a8e68";
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }

    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChanelHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }


  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{

    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=33cb32e8dc8a4d97bdad3b0ef32a8e68";
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }

    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Error");
  }

}