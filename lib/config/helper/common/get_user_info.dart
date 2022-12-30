import 'package:shared_preferences/shared_preferences.dart';

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt("userId") == null) {
    return 0;
  } else {
    return prefs.getInt("userId")!;
  }
}
