import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/config.dart';
import '../../../config/helper/common/get_user_info.dart' as common;

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

class Coupon {
  String url = Api.couponlist;
  String urltest = "http://127.0.0.1:7070/api/coupon_list";
  Future<List> getCouponList() async {
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List> GetTnC() async {
    String url = Api.termandcondition;

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

  Future<List> GetpurchasedDetail(String id) async {
    String url = Api.purchasecouponlist + '/' + id;
    print(url);
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List> getString(String id) async {
    String url = Api.getcoupondetail + "/" + id;
    print(url);
    String urltest = "http://127.0.0.1:7070/api/getcoupondetail/" + id;

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        //  print(jsonDecode(response.body)['Url']);
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    int? intvalue = prefs.getInt('userId');
    // print(intvalue);
    return intvalue;
  }

  Future<String> PurchaseCoupon(String id, String Couponid) async {
    int currentUserId = await common.getUserId();
    String safeId = currentUserId.toString();
    String url = "${Api.purchasecoupon}/$safeId/$Couponid";
    Map<String, String> headers = await common.getAuthHeaders();

    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['message'];
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
