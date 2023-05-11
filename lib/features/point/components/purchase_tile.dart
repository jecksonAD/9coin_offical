import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';

class PurchaseTile extends StatefulWidget {
  final Function()? onTap;
  final String id;
  final String date;
  final String title;
  final String subtitle;
  final String type;
  final String point;
  final bool isShowDivider;
  const PurchaseTile({
    Key? key,
    this.onTap,
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.point,
    this.isShowDivider = true,
  }) : super(key: key);

  @override
  State<PurchaseTile> createState() => _PurchaseTileState();
}

class _PurchaseTileState extends State<PurchaseTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          onTap: widget.onTap,
          leading: Text(widget.date,
              style: CoinTextStyle.title3.copyWith(height: 1.6)),
          title: Text(widget.title, style: CoinTextStyle.title3),
          subtitle: Text(widget.subtitle, style: CoinTextStyle.title3),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${widget.point} point", style: CoinTextStyle.orangeTitle3),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () async {
                    print('test');
                    String url = '';
                    if (widget.type == "coupon") {
                      url = Api.fileDownloadUrl;
                      url = url.replaceAll(":type", "coupon");
                      url = url.replaceAll(":id", widget.id);
                    }
                    if (widget.type == "transaction") {
                      url =
                          'https://9coin.s3.ap-southeast-1.amazonaws.com/Invoices/' +
                              widget.id +
                              '.pdf';
                    }
                    if (widget.type == "product") {
                      url = Api.fileDownloadUrl;
                      url = url.replaceAll(":type", "product");
                      url = url.replaceAll(":id", widget.id);
                    }
                    if (widget.type == "topup") {
                      url = Api.fileDownloadUrl;
                      url = url.replaceAll(":type", "topup");
                      url = url.replaceAll(":id", widget.id);
                    }

                    if (widget.type == "returnpointshistory") {
                      url = Api.fileDownloadUrl;
                      url = url.replaceAll(":type", "returnpointshistory");
                      url = url.replaceAll(":id", widget.id);
                    }

                    if (!await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    )) {}
                    throw 'Could not launch $url';
                  },

                  /*  String uri =
                        "https://9coin.s3.ap-southeast-1.amazonaws.com/Invoices/222321.pdf";

                    await downloadFile(uri, "test.pdf");
                  },*/
                  child: Image.asset(Assets.download, height: 15, width: 15)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        widget.isShowDivider ? const Divider() : const Opacity(opacity: 0),
      ],
    );
  }

  Future<void> downloadFile(uri, fileName) async {
    String savePath = await getFilePath(fileName);
    print(savePath);

    /* final taskId = await FlutterDownloader.enqueue(
      url: uri,
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: savePath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
*/
    /* Dio dio = Dio();

    dio.download(uri, savePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        //you can build progressbar feature too
      } else {}
    });*/
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    path = '${dir.path}';

    return path;
  }
}
