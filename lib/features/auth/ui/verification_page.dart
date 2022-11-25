import 'package:flutter/material.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/auth/services/auth.dart';
import 'package:ninecoin/features/auth/ui/login_page.dart';
import 'package:ninecoin/features/home/ui/home_page.dart';
import 'package:ninecoin/typography/text_styles.dart';
import 'package:ninecoin/utilities/dialogs/new_password_reset.dart';
import 'package:ninecoin/utilities/dialogs/password_reset.dart';

import '../../../utilities/dialogs/email_verification.dart';
import '../../../utilities/dialogs/email_verification_bar.dart';

class VerificationPage extends StatefulWidget {
  static Route route({required String email}) {
    return MaterialPageRoute(
        builder: (context) => VerificationPage(email: email));
  }

  final String email;
  const VerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CoinColors.black12,
            centerTitle: true,
            title: Text(
              "Verification Page",
              style: CoinTextStyle.title1,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter Verification Code",
                    style: CoinTextStyle.title1.copyWith(
                      color: CoinColors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Verification have been send to your email " +
                          widget.email,
                      style: CoinTextStyle.title4,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextField(
                      controller: emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Verification Code",
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      print(emailController.text);
                      if (await showEmailVerification(context)) {
                        Verification(
                                email: widget.email,
                                verificationcode: emailController.text)
                            .then((value) async {
                          print('verification' + value);
                          if (await showNewVerificationDialog(context, value)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomePage()));
                          }
                        });
                      }
                    },
                    child: Text(
                      "Verify",
                      style: CoinTextStyle.title2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
