import 'package:shared_preferences/shared_preferences.dart';

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt("userId") == null) {
    return 0;
  } else {
    return prefs.getInt("userId")!;
  }
}

Future<Map<String, String>> getAuthHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("jwt");
  String? tokenType = prefs.getString("jwtType");
  if (token != null && tokenType != null) {
    return {
      "Content-Type": "application/json",
      "Authorization": "$tokenType $token",
    };
  }
  return {"Content-Type": "application/json"};
}
