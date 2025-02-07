import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/coupon/components/discount_coupon_card.dart';
import 'package:ninecoin/features/notification/ui/notifications_page.dart';
import 'package:ninecoin/features/profile/ui/profile_page.dart';
import 'package:ninecoin/model/auth/login/login_response.dart';
import 'package:ninecoin/typography/text_styles.dart';

import '../../home/components/circle_icon.dart';
import 'active_coupon_details.dart';
import 'purchased_coupon_details.dart';
import '../api/coupon.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late String Userid;
  late String purchasecondition = "";

  Coupon getdata = new Coupon();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    getdata.getUserId().then((value) {
      setState(() {
        Userid = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          padding: const EdgeInsets.only(bottom: 12),
          unselectedLabelColor: CoinColors.black54,
          labelColor: CoinColors.orange,
          labelStyle: CoinTextStyle.orangeTitle3,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Purchased'),
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: CoinColors.orange,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ActiveDiscountCopoun(),
              const PurchasedDiscountCopoun(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ActiveDiscountCopoun extends StatelessWidget {
  final List<String> copouns = [
    Assets.discountCopoun1,
    Assets.discountCopoun2,
    Assets.discountCopoun3,
    Assets.discountCopoun3
  ];

  ActiveDiscountCopoun({Key? key}) : super(key: key);
  Coupon couponlist = Coupon();

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    late double font1;
    late double font2;
    late double font3;
    late double font4;
    Size size = MediaQuery.of(context).size;
    font1 = size.width * 1.0;
    font2 = size.height * 0.1;
    font3 = size.height * 0.2;
    font4 = size.height * 0.3;
    return FutureBuilder<List>(
        future: couponlist.getCouponList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 6),
                      DiscountCouponCard(
                          data: snapshot.data![index],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ActiveCouponDetails(
                                      snapshot.data![index]['id'],
                                    )));
                          },
                          page: "Buy",
                          period: snapshot.data![index]['SEdate'].toString(),
                          imageUrl:
                              snapshot.data![index]['imageurl'].toString(),
                          maxredeemper: snapshot.data![index]['maxredeemperson']
                              .toString(),
                          title: snapshot.data![index]['title'],
                          originalpoint:
                              snapshot.data![index]['originalpoint'].toString(),
                          promopoint: snapshot.data![index]['promotionpoint']
                              .toString()),
                      const SizedBox(height: 6),
                    ],
                  );
                });
          } else {
            return const Center(child: Text("No Data"));
          }
        });
  }
}

class PurchasedDiscountCopoun extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) => PurchasedDiscountCopoun());
  }

  const PurchasedDiscountCopoun({Key? key}) : super(key: key);

  @override
  State<PurchasedDiscountCopoun> createState() =>
      _PurchasedDiscountCopounState();
}

class _PurchasedDiscountCopounState extends State<PurchasedDiscountCopoun> {
  late String Userid = "";
  late String purchasecondition = "";
  Coupon getdata = new Coupon();
  @override
  void initState() {
    super.initState();
    getdata.getUserId().then((value) {
      //print('test' + value.toString());
      setState(() {
        Userid = value.toString();
        // print(Userid);
      });
    });
  }

  final List<String> copouns = [
    Assets.discountCopoun1,
  ];

  @override
  Widget build(BuildContext context) {
    Coupon couponlist = Coupon();
    return FutureBuilder<List>(
        future: couponlist.GetpurchasedDetail(Userid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 6),
                      DiscountCouponCard(
                          data: snapshot.data![index],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PurchasedCouponDetails(
                                    snapshot.data![index]['id'],
                                    snapshot.data![index]['couponid'])));
                          },
                          page: "Collect",
                          period: "null",
                          imageUrl:
                              snapshot.data![index]['imageurl'].toString(),
                          maxredeemper: snapshot.data![index]['maxredeemperson']
                              .toString(),
                          title: snapshot.data![index]['title'],
                          originalpoint:
                              snapshot.data![index]['originalpoint'].toString(),
                          promopoint: snapshot.data![index]['promotionpoint']
                              .toString()),
                    ],
                  );
                });
          } else {
            return const Center(child: Text("No Data"));
          }
        });
  }
}
