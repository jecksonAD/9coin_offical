import 'package:flutter/material.dart';
import 'package:ninecoin/features/point/api/transaction.dart';
import 'package:ninecoin/features/point/components/purchase_tile.dart';

import '../../../config/helper/common/get_user_info.dart' as getid;

class ReturnPointsHistoryPage extends StatefulWidget {
  const ReturnPointsHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReturnPointsHistoryPage> createState() =>
      _ReturnPointsHistoryPageState();
}

class _ReturnPointsHistoryPageState extends State<ReturnPointsHistoryPage> {
  @override
  int? userId;

  @override
  void initState() {
    getid.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    transaction getdata = transaction();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: FutureBuilder<List>(
        future: getdata.getReturnPointsHistory(userId.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      PurchaseTile(
                          type: "returnpointshistory",
                          id: snapshot.data![index]['id'].toString(),
                          date: snapshot.data![index]['date_'],
                          title: snapshot.data![index]['packagename'],
                          subtitle: "",
                          point: snapshot.data![index]['point'].toString()),
                    ],
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
