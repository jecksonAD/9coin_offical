import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/features/point/services/url_launcher.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpsPage extends StatelessWidget {
  static Route<HelpsPage> route() {
    return MaterialPageRoute(builder: (context) => const HelpsPage());
  }

  const HelpsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Help",
          style: CoinTextStyle.title2Bold,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                Assets.help,
                height: 70,
                width: 70,
                color: CoinColors.orange12,
              ),
              const SizedBox(height: 15),
              Text(
                "Needs Help?",
                textAlign: TextAlign.center,
                style: CoinTextStyle.title2Bold,
              ),
              const SizedBox(height: 10),
              const Text(
                "For The Assistant, Please Contact Us",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  int phone = 0193190602;

                  final url = 'https://wa.me/$phone';
                  await launchUrlString(url,
                      mode: LaunchMode.externalApplication);
                },
                style: ElevatedButton.styleFrom(
                  primary: CoinColors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.whatsapp),
                      const SizedBox(width: 5),
                      Text("Chat with us on WhatsApp",
                          style: CoinTextStyle.title4Bold),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
