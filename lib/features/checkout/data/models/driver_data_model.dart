import 'dart:convert';

import 'package:otlob_gas/features/checkout/domain/entities/driver_data.dart';

class DriverDataModel extends DriverData {
  DriverDataModel({
    super.longitude,
    super.latitude,
    super.name,
    super.image,
    super.rating,
    super.imageForWeb,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
      'name': name,
      'image': image,
      'image_for_web': imageForWeb,
    };
  }

  factory DriverDataModel.fromMap(Map<String, dynamic> map) {
    return DriverDataModel(
      longitude: map['longitude'],
      latitude: map['latitude'],
      name: map['name'],
      image: map['image'],
      rating: map['rating'].toString(),
      imageForWeb: map['image_for_web'],
    );
  }

  String toJson() => json.encode(toMap());
  factory DriverDataModel.fromJson(String source) =>
      DriverDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
