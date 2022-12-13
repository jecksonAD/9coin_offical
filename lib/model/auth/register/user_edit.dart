// To parse this JSON data, do
//
//     final userRegister = userRegisterFromMap(jsonString);

import 'dart:convert';

UserEdit userRegisterFromMap(String str) => UserEdit.fromMap(json.decode(str));

String userRegisterToMap(UserEdit data) => json.encode(data.toMap());

class UserEdit {
  UserEdit({
    this.name,
    this.gender,
    this.address,
    this.phonenumber,
  });

  final String? name;
  final String? gender;
  final String? address;
  final String? phonenumber;

  factory UserEdit.fromMap(Map<String, dynamic> json) => UserEdit(
        name: json["name"],
        gender: json["gender"],
        address: json["address"],
        phonenumber: json["phonenumber"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "gender": gender,
        "address": address,
        "phonenumber": phonenumber,
      };
}
