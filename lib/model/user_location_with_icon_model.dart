// To parse this JSON data, do
//
//     final userLocationModel = userLocationModelFromJson(jsonString);
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

UserLocationWithIconModel userLocationModelFromJson(String str) => UserLocationWithIconModel.fromJson(json.decode(str));

String userLocationModelToJson(UserLocationWithIconModel data) => json.encode(data.toJson());

class UserLocationWithIconModel {
  BitmapDescriptor image;
  String name;
  double lat;
  double long;

  UserLocationWithIconModel({
    required this.image,
    required this.name,
    required this.lat,
    required this.long,
  });

  factory UserLocationWithIconModel.fromJson(Map<String, dynamic> json) => UserLocationWithIconModel(
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
