import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/api/tnc.dart';
import 'package:ninecoin/typography/text_styles.dart';

class LuckDrawInformationPage extends StatefulWidget {
  static Route<LuckDrawInformationPage> route() {
    return MaterialPageRoute(
        builder: (context) => const LuckDrawInformationPage());
  }

  const LuckDrawInformationPage({Key? key}) : super(key: key);

  @override
  State<LuckDrawInformationPage> createState() =>
      _LuckDrawInformationPageState();
}

class _LuckDrawInformationPageState extends State<LuckDrawInformationPage> {
  Tnc getdata = new Tnc();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Lucky Draw Information",
              style: CoinTextStyle.title2Bold,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: FutureBuilder<List>(
              future: getdata.GetTnCLuckyDraw(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(children: [
                    Text(
                      "How To Use a Lucky Draw",
                      style: CoinTextStyle.title2Bold.copyWith(
                        color: CoinColors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Go To Luckydraw Page To Purchase The Entry For LuckyDraw,Winner will be announce.",
                      style: CoinTextStyle.title3,
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "Below Was the Term And Condition Along With Step To Participate Lucky Draw :",
                      style: CoinTextStyle.orangeTitle3,
                    ),
                    Column(
                      children: <Widget>[
                        for (int i = 0;
                            i < snapshot.data![0]['servicecount'];
                            i++)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    snapshot.data![0]
                                        ['service_' + i.toString()],
                                    style: CoinTextStyle.title4.copyWith(
                                      letterSpacing: 0.5,
                                    )),
                              ),
                              const SizedBox(height: 6),
                            ],
                          )
                      ],
                    ),
                  ]);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
