import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/app/size_config.dart';

import 'api/news_repository.dart';
import 'bloc/news_bloc.dart';
import 'bloc/news_event.dart';
import 'view/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return OrientationBuilder(builder: (context2,orientation){
        SizeConfig.init(constraints, orientation);
            return MaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
        );

      },);
    });
  }
}

