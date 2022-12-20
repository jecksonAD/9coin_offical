import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/news/components/rounded_news_card.dart';
import 'package:ninecoin/features/news/services/news.dart';

import '../../../model/news/news_model.dart';
import 'news_details_page.dart';

// ignore: must_be_immutable
class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  //late GetNews news;
  late List news;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    getNewsDetail().then((value) {
      setState(() {
        loading = false;
        print(value);
        news = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: news.length,
            itemBuilder: (context, index) {
              return RoundedNewsCard(
                onTap: () {
                  Navigator.push(
                      context, NewsDetailsPage.route(news: news, index: index));
                },
                imageUrl: news[index]['photo'],
                date: news[index]['date'],
                title: news[index]['name'],
                desc: news[index]['description'],
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
  }
}
