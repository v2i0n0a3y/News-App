
import 'package:newzzindia/model/categories_news_model.dart';

import '../model/news_chanel_headlines_model.dart';
import '../repository/news_repository.dart';

class NewsViewModel{

  final _rep = NewsRepository();

  Future<NewsChanelHeadlinesModel> fetchNewChanelHeadLineApi(String channelName)async{
    final response = await _rep.fetchNewChanelHeadLineApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}