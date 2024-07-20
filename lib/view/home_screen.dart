import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newzzindia/model/news_chanel_headlines_model.dart';
import 'package:newzzindia/view/category_screen.dart';
import 'package:newzzindia/view/news_detail_screen.dart';

import '../model/categories_news_model.dart';
import '../view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, cnn, google, hindu}

class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  final format = DateFormat('MMMM dd, yyyy');
  String name = "the-hindu";


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen()));
            },
            icon:Icon(Icons.drag_indicator_sharp)),
        title: Text("News",
          style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
            onSelected:(FilterList item){

              if(FilterList.bbcNews.name == item.name){
                name = "bbc-news";
              }
              if(FilterList.cnn.name == item.name){
                name = "cnn";
              }
              if(FilterList.google.name == item.name){
              name = "google-news-in";
              }
              if(FilterList.hindu.name == item.name){
                name = "the-hindu";
              }
              setState(() {
                selectedMenu = item;
              });
            } ,
            icon: Icon(Icons.more_vert_sharp),
            initialValue: selectedMenu,
              itemBuilder: (BuildContext context)=> <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews,
                    child: Text("BBC News")
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.cnn,
                    child: Text("CNN")
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.hindu,
                    child: Text("The Hindu")
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.google,
                    child: Text("Google News")
                ),
              ],
          )

        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChanelHeadlinesModel>(
                future: newsViewModel.fetchNewChanelHeadLineApi(name),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),

                    );
                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){

                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  NewsDetailScreen(
                                      newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle: snapshot.data!.articles![index].title.toString(),
                                  newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString())));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height : height * 0.6,
                                    width: width * .9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                          fit: BoxFit.cover,
                                        placeholder: (context, url)=> Container(child: spinKit2,),
                                        errorWidget: (context, url, error)=> Icon(Icons.error_outline, color: Colors.red,)
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.all(15),
                                        height: height * .18,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                               width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index].title.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data!.articles![index].source!.name.toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600),),
                                                  Text(
                                                    format.format(dateTime),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),)
                                                ],
                                              ),

                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi("General"),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),

                    );
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index){

                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context, url)=> Container(child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      ),
                                      errorWidget: (context, url, error)=> Icon(Icons.error_outline, color: Colors.red,)
                                  ),
                                ),
                                Expanded(child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString()
                                        ,maxLines:3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                          Text(format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
