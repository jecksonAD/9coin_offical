import 'package:flutter/material.dart';
import 'package:ninecoin/features/point/api/transaction.dart';
import 'package:ninecoin/features/point/components/purchase_tile.dart';

import '../../../config/helper/common/get_user_info.dart' as getid;

class ProductPurchaseHistoryPage extends StatefulWidget {
  const ProductPurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  State<ProductPurchaseHistoryPage> createState() =>
      _ProductPurchaseHistoryPageState();
}

class _ProductPurchaseHistoryPageState
    extends State<ProductPurchaseHistoryPage> {
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
        future: getdata.getProductRedeemtransactionlist(userId.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      PurchaseTile(
                          type: "product",
                          id: snapshot.data![index]['id'].toString(),
                          date: snapshot.data![index]['date_'],
                          title: snapshot.data![index]['name'],
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
