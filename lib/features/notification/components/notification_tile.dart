import 'package:flutter/material.dart';
import 'package:ninecoin/typography/text_styles.dart';

import '../../../main.dart';
import '../../../model/news/news_model.dart';
import '../../category/api/merchant.dart';
import '../../category/ui/product_details_page.dart';
import '../../coupon/ui/active_coupon_details.dart';
import '../../lucky_draw/services/lucky_draw.dart';
import '../../lucky_draw/ui/draw_details_page.dart';
import '../../news/services/news.dart';
import '../../news/ui/news_details_notification_page.dart';
import '../ui/notification_detail_page.dart';

class NotificationTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String date;
  //final String data;
  final String notifiable_type;
  final String notifiable_id;

  const NotificationTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.notifiable_type,
      required this.notifiable_id,
      // required this.data,
      required this.date})
      : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late String sub;
  late String Notidata;
  void initState() {
    // TODO: implement initState
    if (widget.subtitle.length > 20) {
      sub = widget.subtitle.substring(0, 15);
    } else {
      sub = widget.subtitle;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(widget.notifiable_type);
        if (widget.notifiable_type == "News") {
          GetNews news;
          Newsdetail(widget.notifiable_id).then((value) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsDetailsNotificationPage(
                      news: value,
                      index: 0,
                    )));
          });
        } else if (widget.notifiable_type == "Merchant") {
          print(widget.notifiable_type);
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    value[0]['id'],
                    value[0]['name'],
                    value[0]['image'],
                    value[0]['totalproductimage'],
                    value[0]['randomnumber'])));
          });
        } else if (widget.notifiable_type == "LuckyDraw") {
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            print(value[0]['id']);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    value[0]['id'],
                    value[0]['name'],
                    value[0]['image'],
                    value[0]['totalproductimage'],
                    value[0]['randomnumber'])));
          });
        } else if (widget.notifiable_type == "Notification") {
          //  print(notifiable_type);
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotificationDetailsNotificationPage(
                      title: widget.title,
                      subtitle: widget.subtitle,
                      date: widget.date,
                    )));
          });
        } else if (widget.notifiable_type == "Coupon") {
          //  print(notifiable_type);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ActiveCouponDetails(
                    int.parse(widget.notifiable_id),
                  )));
        } else if (widget.notifiable_type == "Lucky Draw") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const App(
                        page: 3,
                      )),
              (Route<dynamic> route) => false);
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: widget.icon,
            title: Text(widget.title, style: CoinTextStyle.title3Bold),
            subtitle: Text(sub, style: CoinTextStyle.title4),
            trailing: Text(widget.date),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
