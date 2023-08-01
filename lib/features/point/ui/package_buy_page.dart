import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/api/tnc.dart';
import 'package:ninecoin/features/point/api/pointpackage.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'in_app_webview_page.dart';
import '../../../config/config.dart';

import 'package:in_app_webview/in_app_webview.dart';

class PackageBuyPage extends StatefulWidget {
  static route(
      {required pointpackageresponse pointpackage, required int index}) {
    return MaterialPageRoute(builder: (context) {
      return PackageBuyPage(pointpackage: pointpackage, index: index);
    });
  }

  final pointpackageresponse pointpackage;
  final int index;

  const PackageBuyPage(
      {Key? key, required this.pointpackage, required this.index})
      : super(key: key);

  @override
  State<PackageBuyPage> createState() => _PackageBuyPageState();
}

class _PackageBuyPageState extends State<PackageBuyPage> {
  late String Userid = "";
  pointpackage getdata = new pointpackage();
  Tnc gettnc = new Tnc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata.getUserId().then((value) {
      setState(() {
        Userid = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.pointpackage.data[widget.index].name),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.pointpackage.data[widget.index].name,
                      style: CoinTextStyle.title3),
                  const SizedBox(height: 3.0),
                  Text(widget.pointpackage.data[widget.index].description,
                      style: CoinTextStyle.title4),
                  const SizedBox(height: 18.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: widget.pointpackage.data[widget.index].point
                              .toString(),
                          style:
                              CoinTextStyle.orangeTitle1.copyWith(fontSize: 26),
                          children: [
                            TextSpan(
                              text: " Point",
                              style: CoinTextStyle.title2,
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Total :",
                          style: CoinTextStyle.title2,
                          children: [
                            TextSpan(
                              text: "RM " +
                                  widget.pointpackage.data[widget.index].myr,
                              style: CoinTextStyle.orangeTitle1
                                  .copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text("Term and Condition",
                      style: CoinTextStyle.title3Bold
                          .copyWith(color: CoinColors.dialogTextColor)),
                  const SizedBox(height: 6.0),
                  FutureBuilder<List>(
                      future: gettnc.GetTncPointPackage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                              child: SingleChildScrollView(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 9),
                                      child: Column(
                                        children: <Widget>[
                                          for (int i = 0;
                                              i <
                                                  snapshot.data![0]
                                                      ['servicecount'];
                                              i++)
                                            Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      snapshot.data![0]
                                                          ['service_$i'],
                                                      style: CoinTextStyle
                                                          .title3
                                                          .copyWith(
                                                        letterSpacing: 0.5,
                                                      )),
                                                ),
                                                const SizedBox(height: 6.0),
                                              ],
                                            )
                                        ],
                                      ))));
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String url = Api.buypointpackage +
                    "/" +
                    Userid.toString() +
                    "/" +
                    widget.pointpackage.data[widget.index].id.toString();
                try {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InAppWebViewPage(url: url),
                    ),
                  );
                } catch (e) {
                  throw 'Could not launch $url';
                }
              },
              //  const urls = 'https://www.google.com';
              //   if (!await launchUrl(
              //     Uri.parse(url),
              //     mode: LaunchMode.inAppWebView,
              //   )) {}
              //   throw 'Could not launch $url';
              // },
              child: const Text("Pay"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
