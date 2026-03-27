import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/news/presentation/widget/news_list_view.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../../../core/constant/constants.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News'),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: NewsListView()));
  }
}
