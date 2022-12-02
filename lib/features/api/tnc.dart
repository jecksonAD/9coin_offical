import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/config.dart';

class CouponDetail {
  final int id;
  final String title;
  final String email;

  const CouponDetail(
      {required this.id, required this.title, required this.email});

  factory CouponDetail.fromJson(Map<String, dynamic> json) {
    return CouponDetail(
        id: json['id'], title: json['title'], email: json['email']);
  }
}

class Tnc {
  Future<List> GetTnCLuckyDraw() async {
    String url = Api.luckydrawtnc;

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List> GetTncPointPackage() async {
    String url = Api.pointpackagetnc;

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
