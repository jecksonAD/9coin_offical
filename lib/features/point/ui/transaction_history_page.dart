import 'package:flutter/material.dart';
import 'package:ninecoin/features/point/api/transaction.dart';
import 'package:ninecoin/features/point/components/transaction_tile.dart';
import 'package:ninecoin/features/point/ui/transaction_details_page.dart';
import '../../../config/helper/common/get_user_info.dart' as getid;

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: FutureBuilder<List>(
        future: getdata.gettopuptransactionlist(userId.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return TransactionTile(
                    onTap: () {
                      Navigator.push(context, TranctionDetailsPage.route());
                    },
                    date: snapshot.data![index]['date_'],
                    packageNum: snapshot.data![index]['packagename'],
                    point: snapshot.data![index]['point'],
                    pointDetail: snapshot.data![index]['point'],
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
