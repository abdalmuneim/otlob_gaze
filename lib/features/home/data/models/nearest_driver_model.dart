import 'dart:convert';

import 'package:otlob_gas/features/home/domain/entities/nearest_driver.dart';

class NearestDriverModel extends NearestDriver {
  NearestDriverModel(
      {super.id,
      super.name,
      super.latitude,
      super.longitude,
      super.distance,
      super.imageForWeb});

  NearestDriverModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'] is double
        ? json['distance']
        : double.tryParse(json['distance'].toString());
    imageForWeb = json['image_for_web'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['image_for_web'] = imageForWeb;
    return data;
  }

  String toJson() => json.encode(toMap());

  factory NearestDriverModel.fromJson(String source) =>
      NearestDriverModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
