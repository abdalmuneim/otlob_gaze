import 'dart:convert';

import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';

class UserLocationModel extends UserLocation {
  UserLocationModel(
      {super.buildingNumber,
      super.floorNumber,
      super.id,
      super.title,
      super.lat,
      super.long,
      super.defaultLocation});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      if (lat != null && lat!.isNotEmpty) 'lat': lat,
      if (long != null && long!.isNotEmpty) 'long': long,
      if (title != null && title!.isNotEmpty) 'title': title,
      if (floorNumber != null && floorNumber!.isNotEmpty)
        'floor_nu': floorNumber,
      if (buildingNumber != null && buildingNumber!.isNotEmpty)
        'building_nu': buildingNumber,
      if (defaultLocation != null) 'default': defaultLocation! ? '1' : '0',
    };
  }

  factory UserLocationModel.fromMap(Map<String, dynamic> map) {
    return UserLocationModel(
      id: map['id'],
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
      title: map['title'] ?? '',
      floorNumber: map['floor_nu'] ?? '',
      buildingNumber: map['building_nu'] ?? '',
      defaultLocation: map['default'] == null
          ? false
          : map['default'].toString() == '0'
              ? false
              : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocationModel.fromJson(String source) =>
      UserLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
