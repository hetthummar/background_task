// To parse this JSON data, do
//
//     final userLocationModel = userLocationModelFromJson(jsonString);

import 'dart:convert';

UserLocationModel userLocationModelFromJson(String str) => UserLocationModel.fromJson(json.decode(str));

String userLocationModelToJson(UserLocationModel data) => json.encode(data.toJson());

class UserLocationModel {
  String image;
  String name;
  double lat;
  double long;

  UserLocationModel({
    required this.image,
    required this.name,
    required this.lat,
    required this.long,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) => UserLocationModel(
    image: json["image"],
    name: json["name"],
    lat: json["lat"]?.toDouble(),
    long: json["long"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "lat": lat,
    "long": long,
  };
}
