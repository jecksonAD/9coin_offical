import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/features/point/api/pointpackage.dart';
import 'package:ninecoin/features/point/components/buy_point_card_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package_buy_page.dart';

class BuyPointPackagePage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => BuyPointPackagePage());
  }

  BuyPointPackagePage({Key? key}) : super(key: key);

  @override
  State<BuyPointPackagePage> createState() => _BuyPointPackagePageState();
}

class _BuyPointPackagePageState extends State<BuyPointPackagePage> {
  pointpackage getdata = pointpackage();
  bool loading = true;
  late pointpackageresponse pointpackageresponses;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    getdata.getpointpackage().then((value) {
      setState(() {
        pointpackageresponses = value;
        loading = false;
    
      });
      // print(pointpackageresponses);
    });
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    setState(() {
      initState();
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoinColors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Buy Point Package"),
      ),
      body: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullUp: true,
          child: !loading
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pointpackageresponses.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        BuyPointCardTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                PackageBuyPage.route(
                                    pointpackage: pointpackageresponses,
                                    index: index));
                          },
                          packageNum: pointpackageresponses.data![index].name,
                          point: pointpackageresponses.data![index].point,
                          pointDetail: "RM " +
                              pointpackageresponses.data![index].myr.toString(),
                        ),
                      ],
                    );
                  })
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class Package extends StatelessWidget {
  pointpackage getdata = pointpackage();
  late pointpackageresponse pointpackageresponses;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<pointpackageresponse>(
      future: getdata.getpointpackage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pointpackageresponses = snapshot.data!;
          return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pointpackageresponses.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    BuyPointCardTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PackageBuyPage.route(
                                pointpackage: pointpackageresponses,
                                index: index));
                      },
                      packageNum: pointpackageresponses.data![index].name,
                      point: pointpackageresponses.data![index].point,
                      pointDetail: "RM " +
                          pointpackageresponses.data![index].myr.toString(),
                    ),
                  ],
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
