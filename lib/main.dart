import 'package:flutter/material.dart';
import 'package:ninecoin/apptheme/apptheme.dart';
import 'package:ninecoin/l10n/app_localizations.dart';

import 'features/auth/ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App(
    page: 0,
  ));
}

class App extends StatelessWidget {
  final int? page;
  const App({Key? key, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.standard,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const LoginPage());
  }
}
