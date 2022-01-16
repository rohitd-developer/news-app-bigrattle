import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/bloc/news_bloc.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/app/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
class NewsDetailPage extends StatefulWidget {
  final Articles article;

  const NewsDetailPage({Key key, this.article}) : super(key: key);
  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'),),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('${widget.article.image}',height: 30.h,width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
            SizedBox(height: 2.h,),
            Padding(
              padding:  EdgeInsets.only(left: 2.w,right: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.article.title}',style: TextStyle(fontSize: 3.0.t,fontWeight: FontWeight.w600),),
                  SizedBox(height: 2.h,),
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.article
                      .publishedAt))}'),
                  SizedBox(height: 2.h,),
                  Text('Source:${widget.article.source.name}'),
                  SizedBox(height: 2.h,),

                  Text('Source URL:'),
                  SizedBox(height: 1.h,),



                  GestureDetector(
                    onTap: () async{
                      if (await canLaunch(widget.article.source.url)) {
                        await launch(widget.article.source.url, forceSafariVC: false, forceWebView: false);
                      } else {
                        throw 'Could not launch url';
                      }
                    },
                      child: Text(' ${widget.article.source.url}',style: TextStyle(color: Colors.blue,fontSize: 2.0.t),)),

                  SizedBox(height: 2.h,),



                  Text('${widget.article.content}',style: TextStyle(fontSize: 2.t,fontWeight: FontWeight.w400),),

                  SizedBox(height: 2.h,),

                  Text('Link:',style: TextStyle(fontSize: 2.t,fontWeight: FontWeight.w400),),

                  SizedBox(height: 1.h,),


                  GestureDetector(
                    onTap: () async{
                      if (await canLaunch(widget.article.url)) {
                      await launch(widget.article.url, forceSafariVC: false, forceWebView: false);
                      } else {
                      throw 'Could not launch url';
                      }
                    },
                      child: Text('${widget.article.url}',style: TextStyle(color: Colors.blue),)),

                  SizedBox(height: 2.h,)

                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
