import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/typography/text_styles.dart';

import '../../../model/news/news_model.dart';

class NewsDetailsPage extends StatelessWidget {
  static route({required List news, required int index}) {
    return MaterialPageRoute(
      builder: (context) => NewsDetailsPage(
        news: news,
        index: index,
      ),
    );
  }

  final List news;
  final int index;
  const NewsDetailsPage({Key? key, required this.news, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("News"),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 240,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Image.network(news[index]['photo'],
                            fit: BoxFit.cover)),
                  ],
                ),
              ),
              Text(news[index]['date'],
                  style:
                      CoinTextStyle.title4.copyWith(color: CoinColors.black54)),
              Text(news[index]['name'], style: CoinTextStyle.orangeTitle2),
              const SizedBox(height: 6),
              Text(news[index]['description'], style: CoinTextStyle.title3),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 240),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(
                            child: Image.network(
                                news[index]['Extended_Images'][0]['img'],
                                fit: BoxFit.cover)),
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: <Widget>[
                  for (int i = 0; i < news[index]['news1count']; i++)
                    Column(
                      children: [
                        Text(news[index]['news_1' + i.toString()],
                            textAlign: TextAlign.left,
                            style: CoinTextStyle.title3),
                        const SizedBox(height: 12),
                      ],
                    ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12, top: 12),
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 240),
                child: Row(
                  children: [
                    Expanded(
                        child: Image.network(
                            news[index]['Extended_Images'][1]['img'],
                            fit: BoxFit.cover)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: <Widget>[
                  for (int i = 0; i < news[index]['news2count']; i++)
                    Column(
                      children: [
                        Text(news[index]['news_2' + i.toString()],
                            style: CoinTextStyle.title3),
                        const SizedBox(height: 12),
                      ],
                    ),
                ],
              ),
              /* 
              Container(
                margin: const EdgeInsets.only(bottom: 12, top: 12),
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 240),
                child: Row(
                  children: [
                    Expanded(
                        child: Image.network(news[index].extendedImages[1].img,
                            fit: BoxFit.cover)),
                  ],
                ),
              ),
              Text(
                news[index].extendedDescriptions[1].desc,
                style: CoinTextStyle.title3,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
