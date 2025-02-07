import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../components/redeem_list_tile.dart';
import '../components/redeemed_list_tile.dart';

class RedeemtionsPage extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const RedeemtionsPage());
  }

  const RedeemtionsPage({Key? key}) : super(key: key);

  @override
  State<RedeemtionsPage> createState() => _RedeemtionsPageState();
}

class _RedeemtionsPageState extends State<RedeemtionsPage>
    with TickerProviderStateMixin {
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
    _tabController = TabController(length: 2, vsync: this);

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
            title: const Text("Redemptions"),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullUp: true,
            child: Column(
              children: [
                TabBar(
                  unselectedLabelColor: CoinColors.black54,
                  labelColor: CoinColors.orange,
                  labelStyle: CoinTextStyle.orangeTitle3,
                  tabs: const [
                    Tab(text: 'Redeem'),
                    Tab(text: 'Use'),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: CoinColors.orange,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      RedeemListTile(),
                      RedeemedListTile(),
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
