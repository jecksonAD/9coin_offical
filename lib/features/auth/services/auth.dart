import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ninecoin/model/auth/login/login_response.dart';
import '../../../config/config.dart';
import '../../../config/helper/auth_helper/auth_helper.dart';
import '../../../model/auth/register/register_response.dart';
import '../../../model/auth/register/user_edit.dart';
import '../../../model/auth/register/user_register.dart';

Future<RegisterResponse> registerUser(
    {required UserRegister registerUser}) async {
  String url = Api.register;
  var uri = Uri.parse(url);

  var response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: json.encode(registerUser.toMap()),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    RegisterResponse user =
        RegisterResponse.fromJson(json.decode(response.body));
    // setUser(user);

    //print(user);
    return user;
  } else {
    throw json.decode(response.body)["error"];
  }
}

Future<String> edituser(
    {required UserEdit registerUser, required String userid}) async {
  String url = Api.edituser + '/' + userid;
  var uri = Uri.parse(url);
  print(url);
  var response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: json.encode(registerUser.toMap()),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // setUser(user);

    //print(user);
    LoginResponse user = LoginResponse.fromJson(json.decode(response.body));

    setLoginUserInfo(user);
    print(response.body);
    return 'Success';
  } else {
    print(response.body);
    throw json.decode(response.body)["error"];
  }
}

Future<String> loginUser(
    {required String email,
    required String password,
    required String device_id}) async {
  String url = Api.login;
  var uri = Uri.parse(url);

  var response = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
          {"email": email, "password": password, "device_id": device_id}));
  print("statuscode" + json.decode(response.body)["status_code"].toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (json.decode(response.body)["status_code"] == 200) {
      LoginResponse user = LoginResponse.fromJson(json.decode(response.body));

      setLoginUserInfo(user);
      return "Success";
    } else {
      return "verification needed";
    }
  } else {
    throw json.decode(response.body)["error"];
  }
}

Future<String> Verification(
    {required String email, required String verificationcode}) async {
  String url = Api.verification;
  var uri = Uri.parse(url);

  var response = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "verifcode": verificationcode,
      }));

  if (response.statusCode == 200 || response.statusCode == 201) {
    if (json.decode(response.body)["status_code"] == 200) {
      LoginResponse user = LoginResponse.fromJson(json.decode(response.body));

      setLoginUserInfo(user);
      return "Success";
    } else {
      return "Wrong Verification Code";
    }
  } else {
    throw json.decode(response.body)["error"];
  }
}

Future<String> getUserdata({required String id}) async {
  String url = Api.getuserdata;
  //print(url);
  var uri = Uri.parse(url);

  var response = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id}));
  // print(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
    GetUserData user = GetUserData.fromJson(json.decode(response.body));
    //  print(json.decode(response.body));
    setUserInfo(user);
    return "Success";
  } else {
    throw json.decode(response.body)["error"];
  }
}

Future<String> ForgotPassword({required String email}) async {
  String url = Api.forgetpassword;
  var uri = Uri.parse(url);
  print(url);
  var response = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email}));

  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body)["data"];
  } else {
    throw json.decode(response.body)["error"];
  }
}

Future<String> changePassword(
    {required String currentPassword, required String newPassword}) async {
  String url =
      "${Api.changePassword}?current_password=$currentPassword&new_password=$newPassword";
  var uri = Uri.parse(url);

  String token = await getToken();

  var response = await http.post(uri, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  });
  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body)["success"];
  } else {
    throw json.decode(response.body)["unsuccess"];
  }
}
