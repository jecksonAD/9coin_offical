import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config.dart';
import '../../../config/helper/common/get_user_info.dart' as common;
import 'package:http/http.dart' as http;

class ProductRedeem {
  Future<List> getproductlist() async {
    String url = Api.redeemproductlist;
    print(url);
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

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    int? intvalue = prefs.getInt('userId');
    // print(intvalue);
    return intvalue;
  }

  Future<dynamic> buyproduct(String id, String productid) async {
    int currentUserId = await common.getUserId();
    String safeId = currentUserId.toString();
    String url = "${Api.purchaseproduct}/$safeId/$productid";
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

  Future<List> showpurchasedproduct(String id) async {
    String url = Api.showpurchasedproduct + '/' + id;
    print(url);
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

  Future<List> getproductdetail(String id) async {
    String url = Api.showpurchasedproductdetail + '/' + id;
    print(url);
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
}
