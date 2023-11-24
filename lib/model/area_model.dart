// To parse this JSON data, do
//
//     final areaModel = areaModelFromJson(jsonString);

import 'dart:convert';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));

String areaModelToJson(AreaModel data) => json.encode(data.toJson());

class AreaModel {
  List<Area> area;

  AreaModel({
    required this.area,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    area: List<Area>.from(json["area"].map((x) => Area.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "area": List<dynamic>.from(area.map((x) => x.toJson())),
  };
}

class Area {
  double lat;
  double long;

  Area({
    required this.lat,
    required this.long,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    lat: json["lat"]?.toDouble(),
    long: json["long"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
  };
}
