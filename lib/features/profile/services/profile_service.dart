import 'package:ninecoin/config/helper/auth_helper/auth_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ninecoin/model/news/news_model.dart';

import '../../../config/config.dart';

Future<Map<dynamic, dynamic>?> localUser() async {
  return await getLocalUser();
}

Future<dynamic> accountdeletion(userid) async {
  String url = Api.accountDelete;
  var uri = Uri.parse(url);

  // return (url);
  var response = await http.post(uri, body: {"userid": userid.toString()});

  //print(url);
  if (response.statusCode == 200 || response.statusCode == 201) {
    //print(json.decode(response.body)['data']);

    return json.decode(response.body)['code'];
  } else {
    throw json.decode(response.body)["error"];
  }
}
