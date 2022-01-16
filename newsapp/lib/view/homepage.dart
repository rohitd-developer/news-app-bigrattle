import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/api/news_repository.dart';
import 'package:newsapp/app/size_config.dart';
import 'package:newsapp/bloc/news_bloc.dart';
import 'package:newsapp/bloc/news_event.dart';
import 'package:newsapp/bloc/news_state.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/view/news_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin  {
  final bloc = NewsBloc(NewsRepositoryImplementation())
    ..add(FetchNews());
  TextEditingController searchController = TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);

    super.initState();
    
  }

  void _setActiveTabIndex() {
    int _activeTabIndex = _tabController.index;
    if(_activeTabIndex==0)
      {
        bloc.add(FetchNews());

      }
    else{
      searchController.clear();

      bloc.add(ShowBookmark());
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: Text('News', style: TextStyle(fontSize: 3.0.t),),
        actions: [

        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (val){
            // if(val==1)
            //   {
            //     searchController.clear();
            //     bloc.add(ShowBookmark());
            //   }
            // if(val==0)
            //   {
            //     bloc.add(FetchNews());
            //   }


          },
          labelPadding: EdgeInsets.only(bottom: 1.5.h),
          indicatorWeight: 4,
          tabs: [
            Text('Top Headlines', style: TextStyle(fontSize: 2.5.t),),
            Text('Bookmarks', style: TextStyle(fontSize: 2.5.t),)
          ],
        ),

      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
                child: TextField(
                  controller: searchController,
                  onChanged:(val){
                    if(val.isEmpty)
                      {
                        bloc.add(FetchNews());
                      }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      suffix: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          bloc.add(SearchNews(searchController.text));

                        },
                        child: Container(

                            margin: EdgeInsets.only(right: 4.w),
                            padding: EdgeInsets.only(top: 0.5.h,
                                bottom: 0.5.h,
                                left: 2.w,
                                right: 2.w),
                            color: Colors.blue,
                            child: Text('Search', style: TextStyle(
                                fontSize: 1.8.t, color: Colors.white),)),
                      ),
                      border: OutlineInputBorder()
                  ),
                ),
              ),

              Expanded(
                child: BlocBuilder<NewsBloc, NewsState>(
                    cubit: bloc,
                    builder: (context, state) {

                      if (state is NewsSearch) {
                        return ListView.separated(
                          itemCount: state.news.articles.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsDetailPage(article: state.news.articles[index],)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(


                                      decoration: BoxDecoration(

                                          image: DecorationImage(
                                            image: NetworkImage('${state.news.articles[index].image}'),
                                            fit: BoxFit.fill,
                                          ),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7))
                                      ),
                                      height: 15.h,width: 30.w,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            '${state.news.articles[index]
                                                .title}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 2.5.t,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),

                                          Text(
                                            '${DateFormat('yyyy-MM-dd').format(DateTime.parse(state.news.articles[index]
                                                .publishedAt))}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 1.6.t),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        bloc.add(BookmarkNews(
                                            state.news.articles[index]));

                                      },
                                      child: Icon(
                                        Icons.bookmark_border,
                                        size: 3.h,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) {
                            return SizedBox(
                              height: 1.h,
                            );
                          },
                        );
                      }
                      else if (state is NewsLoading) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      else if (state is NewsLoaded) {
                        return ListView.separated(
                          itemCount: state.news.articles.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsDetailPage(article: state.news.articles[index],)));
                              },
                              child: Card(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(


                                      decoration: BoxDecoration(

                                          image: DecorationImage(
                                            image: NetworkImage('${state.news.articles[index].image}'),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7))
                                      ),
                                      height: 15.h,width: 30.w,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            '${state.news.articles[index]
                                                .title}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 2.5.t,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),

                                          Text(
                                            '${DateFormat('yyyy-MM-dd').format(DateTime.parse(state.news.articles[index]
                                                .publishedAt))}',

                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 1.6.t),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        bloc.add(BookmarkNews(
                                            state.news.articles[index]));




                                      },
                                      child: Icon(
                                        Icons.bookmark_border,
                                        size: 3.h,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) {
                            return SizedBox(
                              height: 1.h,
                            );
                          },
                        );
                      }
                      else if (state is NewsError) {
                        return Center(child: Text(state.message));
                      }


                      return Center(child: CircularProgressIndicator(),);
                    }
                ),
              ),
            ],
          ),
          BlocBuilder<NewsBloc, NewsState>(
            cubit: bloc,
              builder: (_, state) {
                if (state is NewsBookmarkList )
                  return ListView.separated(
                    itemCount: state.news.articles.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsDetailPage(article: state.news.articles[index],)));

                        },
                        child: Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(


                                decoration: BoxDecoration(

                                    image: DecorationImage(
                                      image: NetworkImage('${state.news.articles[index].image}'),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7))
                                ),
                                height: 15.h,width: 30.w,
                              ),

                              SizedBox(
                                width: 3.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      '${state.news.articles[index].title}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 2.5.t,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 1.5.h,
                                    ),

                                    Text(
                                      '${DateFormat('yyyy-MM-dd').format(DateTime.parse(state.news.articles[index]
                                          .publishedAt))}',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 1.6.t),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  bloc.add(RemoveBookmark(state.news.articles[index]));
                                },
                                child: Icon(
                                  Icons.bookmark_outlined,
                                  size: 3.h,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 1.h,
                      );
                    },
                  );
                else if (state is NoBookmarks)
                  {
                   return  Center(child: Text('No Bookmarks',style: TextStyle(fontWeight: FontWeight.w600),),);
                  }

                return     Center(child: CircularProgressIndicator());


              }),

        ],
      ),

    );
  }


}


