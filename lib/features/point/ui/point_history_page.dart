import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/features/point/ui/purchase_history_page.dart';
import 'package:ninecoin/features/point/ui/transaction_history_page.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Product_history_page.dart';
import 'coupon_history_page.dart';

class PointHistoryPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const PointHistoryPage());
  }

  const PointHistoryPage({Key? key}) : super(key: key);

  @override
  State<PointHistoryPage> createState() => _PointHistoryPageState();
}

class _PointHistoryPageState extends State<PointHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
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
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("History"),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullUp: true,
            child: Column(
              children: [
                Container(
                  color: CoinColors.mediumBlack,
                  child: TabBar(
                    unselectedLabelColor: CoinColors.black54,
                    labelColor: CoinColors.orange,
                    labelStyle: CoinTextStyle.orangeTitle3,
                    tabs: const [
                      Tab(text: 'Top Up Transaction'),
                      Tab(text: 'Pruchase History'),
                      Tab(text: 'Coupon History'),
                      Tab(text: 'Product History'),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: CoinColors.orange,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      TransactionHistoryPage(),
                      PurchaseHistoryPage(),
                      CouponHistoryPage(),
                      ProductPurchaseHistoryPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
