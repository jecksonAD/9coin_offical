import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/lucky_draw/components/my_timer_drawall..dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/helper/common/get_user_info.dart';
import '../../../model/luckyDraw/lucky_drawn_response.dart';
import '../services/lucky_draw.dart';
import '../ui/drawn_details_page.dart';
import 'drawn_tile.dart';

class LuckyDrwanItems extends StatefulWidget {
  const LuckyDrwanItems({Key? key}) : super(key: key);

  @override
  State<LuckyDrwanItems> createState() => _LuckyDrwanItemsState();
}

class _LuckyDrwanItemsState extends State<LuckyDrwanItems> {
  String? userId;
  List<String> lukcydrawid = [];
  int? win = 0;
  late LuckyDrawnResponse luckyDrawn;
  Luckydraw updatestatus = Luckydraw();
  Luckydraw getdata = new Luckydraw();
  @override
  void initState() {
    getUserId().then((value) => setState(() {
          userId = value.toString();
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userId == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FutureBuilder<List>(
              future: getdata.getLuckydraw(userId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<List>(
                          future: getdata.getLuckydrawInfo(
                              snapshot.data![index]['luckydrawid'].toString()),
                          builder: (context, indexx) {
                            if (indexx.hasData) {
                              lukcydrawid
                                  .add(snapshot.data![index]['id'].toString());

                              return DrawnTile(
                                onTap: () {},
                                luckydrawid: snapshot.data![index]
                                        ['luckydrawid']
                                    .toString(),
                                id: snapshot.data![index]['id'].toString(),
                                title: indexx.data![0]['name'].toString(),
                                startingDate:
                                    indexx.data![0]['startdate'].toString(),
                                endDate: indexx.data![0]['enddate'].toString(),
                              );
                            } else {
                              return DrawnTile(
                                onTap: () {},
                                title: "",
                                startingDate: "",
                                endDate: "",
                                luckydrawid: "",
                                id: "",
                              );
                            }
                          });
                    },
                  );
                }
              }),
      floatingActionButton:

          // FloatingActionButton(
          //   onPressed: () {},
          // child:
          InkWell(
        onTap: () async {
          if (lukcydrawid.length > 0) {
            // print('size of ' + lukcydrawid.length.toString());
            for (int i = 0; i < lukcydrawid.length; i++) {
              // print('waht is this' + lukcydrawid[i].toString());
              await getLuckyDrawListInfo(lukcydrawid[i]).then((value) {
                //   print('waht is this' + value.data[0].winningstatus.toString());
                updatestatus.updatedrawnstatus(lukcydrawid[i]);
                if (value.data[0].winningstatus == 1) {
                  win = 1;
                  // print('trigger here');
                }
              });
            }
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    alignment: Alignment.center,
                    backgroundColor: CoinColors.transparent,
                    child: DrawAll(win!),
                  );
                });
            //  print('status' + win.toString());
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xffFCBA56),
          ),
          child: Text(
            'Draw All',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
