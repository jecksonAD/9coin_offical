import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config.dart';

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  int? intvalue = prefs.getInt('userId');
  // print(intvalue);
  return intvalue;
}

class transaction {
  late Response response;
  var dio = Dio();

  Future<Response> download() async {
    try {
      response = await dio.download(
          'https://9coin.s3.ap-southeast-1.amazonaws.com/Invoices/222321.pdf',
          './xx.html');
      print(response.data.toString());
      return response.data;
      print(response.data.toString());
// Optionally the request above could also be done as
      response =
          await dio.get('/test', queryParameters: {'id': 12, 'name': 'wendu'});
      print(response.data.toString());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List> gettransactionlist(String id) async {
    String url = Api.gettransaction + "/" + id;

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

  Future<List> getCoupontransactionlist(String id) async {
    String url = Api.getcoupontranction + "/" + id;

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

  Future<List> getProductRedeemtransactionlist(String id) async {
    String url = Api.getproductredeemtranction + "/" + id;

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

  Future<List> gettopuptransactionlist(String id) async {
    String url = Api.topuptransactionlist + "/" + id;

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

  Future<List> getReturnPointsHistory(String id) async {
    String url = "${Api.returnPointsHistory}/$id";

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
