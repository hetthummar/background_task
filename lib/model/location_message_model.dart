// To parse this JSON data, do
//
//     final locationMessageModel = locationMessageModelFromJson(jsonString);

import 'dart:convert';

LocationMessageModel locationMessageModelFromJson(String str) => LocationMessageModel.fromJson(json.decode(str));

String locationMessageModelToJson(LocationMessageModel data) => json.encode(data.toJson());

class LocationMessageModel {
  String name;
  String time;
  String message;

  LocationMessageModel({
    required this.name,
    required this.time,
    required this.message,
  });

  factory LocationMessageModel.fromJson(Map<String, dynamic> json) => LocationMessageModel(
    name: json["name"],
    time: json["time"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "time": time,
    "Message": message,
  };
}
