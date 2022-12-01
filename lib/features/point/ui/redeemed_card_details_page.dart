import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/features/point/api/productredemption.dart';
import 'package:ninecoin/typography/text_styles.dart';

class RedeemedCardDetailsPage extends StatefulWidget {
  final String productid;
  final String productredeemidlist;

  const RedeemedCardDetailsPage(this.productid, this.productredeemidlist);

  @override
  State<RedeemedCardDetailsPage> createState() =>
      _RedeemedCardDetailsPageState();
}

class _RedeemedCardDetailsPageState extends State<RedeemedCardDetailsPage> {
  ProductRedeem getdata = ProductRedeem();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: FutureBuilder<List>(
          future: getdata.getproductdetail(widget.productid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(snapshot.data![0]['title']),
                ),
                body: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  children: [
                    Image.network(snapshot.data![0]['image_url']),
                    const SizedBox(height: 12.0),
                    Text(snapshot.data![0]['name'],
                        style: CoinTextStyle.orangeTitle2),
                    const SizedBox(height: 8.0),
                    Text("Email : " + snapshot.data![0]['email'],
                        style: CoinTextStyle.title3),
                    Text("Contact Number : " + snapshot.data![0]['phonenumber'],
                        style: CoinTextStyle.title3),
                    Text("Address : " + snapshot.data![0]['address'],
                        style: CoinTextStyle.title3),
                    const SizedBox(height: 12.0),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Text("Product", style: CoinTextStyle.orangeTitle3),
                    const SizedBox(height: 6.0),
                    Text(snapshot.data![0]['productname'],
                        style: CoinTextStyle.title3),
                    const SizedBox(height: 8.0),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    //   Text("Redeemed Date", style: CoinTextStyle.orangeTitle3),
                    //  const SizedBox(height: 6.0),
                    //  Text("23/4/2022", style: CoinTextStyle.title3),
                    // const SizedBox(height: 6.0),
                    //const Divider(),
                    RichText(
                      text: TextSpan(
                        text: "Total :",
                        style: CoinTextStyle.title3,
                        children: [
                          TextSpan(
                            text: snapshot.data![0]['point'],
                            style: CoinTextStyle.orangeTitle1.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: "Point",
                                style: CoinTextStyle.orangeTitle1.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Text("Term and Condition",
                        style: CoinTextStyle.orangeTitle3),
                    const SizedBox(height: 6.0),

                    Column(
                      children: <Widget>[
                        for (int i = 0;
                            i < snapshot.data![0]['servicecount'];
                            i++)
                          Column(
                            children: [
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    snapshot.data![0]
                                        ['service_' + i.toString()],
                                    style: CoinTextStyle.title3.copyWith(
                                      letterSpacing: 0.5,
                                    )),
                              ),
                              const SizedBox(height: 6),
                            ],
                          )
                      ],
                    ),

                    const Divider(),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("Redeem Code",
                                style: CoinTextStyle.orangeTitle3),
                            Text(widget.productredeemidlist,
                                style: CoinTextStyle.title3),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
