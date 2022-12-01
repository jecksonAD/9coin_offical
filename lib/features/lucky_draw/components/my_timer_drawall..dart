// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/lucky_draw/services/lucky_draw.dart';

import '../../../main.dart';
import '../../../model/luckyDraw/lucky_draw_response.dart';
import '../ui/drawn_details_page.dart';

class DrawAll extends StatefulWidget {
  final int win;

  const DrawAll(this.win);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<DrawAll> {
  int _counter = 9;
  late final Timer _timer;
  Luckydraw updatestatus = Luckydraw();
  void _startTimer() {
    _counter = 9;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        print(_counter);
        if (_counter >= 0) {
          _counter--;
        } else {
          _timer.cancel();
          //  updatestatus.updatedrawnstatus(widget.LuckrdrawListid);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => App(
                        page: 3,
                      )),
              (route) => false);
        }
      });
    });
  }

  String winner = "";
  String noWin = "";

  /*Future<void> getLuckyWinner() async {
    String name = widget.email!.split("@gmail.com")[0].toString();
    name = name.replaceFirst(name[0], name[0].toUpperCase());
    var response = await getWinner();
    for (var element in response) {
      if (element['winner'].toString().contains(name)) {
        setState(() {
          winner = "win";
          noWin = "";
        });
        _startTimer();
      } else {
        setState(() {
          noWin = "noWin";
        });
      }
    }
  }*/

  late LuckyDrawListResponse luckyDrawListResponse;
  late int winningstatus = 0;
  var image;
  @override
  void initState() {
    _counter = 9;
    super.initState();

    winningstatus = widget.win;
    setState(() {
      _startTimer();
      if (winningstatus == 1) {
        winner = "win";
        noWin = "winner";

        image = Image.asset(
          "assets/prize_gif/prize.gif",
          height: 400.0,
          width: 400.0,
        );
      } else {
        winner = "noWin";
        noWin = "noWin";
        image = Image.asset(
          "assets/prize_gif/no-prize.gif",
          height: 400.0,
          width: 400.0,
        );
      }
    });

    //   getLuckyWinner();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
          alignment: Alignment.center,
          child: winner == ""
              ? Center(
                  child: CircularProgressIndicator(
                  color: CoinColors.dialogTextColor,
                ))
              : image),
    );
  }
}
