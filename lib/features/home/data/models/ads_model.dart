import 'dart:convert';
import 'package:otlob_gas/features/home/domain/entities/ads.dart';

class AdsModel extends Ads {
  AdsModel(
      {super.id, super.image, super.link, super.status, super.imageForWeb});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'link': link,
      'status': status,
      'image_for_web': imageForWeb,
    };
  }

  factory AdsModel.fromMap(Map<String, dynamic> map) {
    return AdsModel(
      id: map['id'],
      image: map['image'] ?? '',
      link: map['link'] ?? '',
      status: map['status'] ?? 0,
      imageForWeb: map['image_for_web'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsModel.fromJson(String source) =>
      AdsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
