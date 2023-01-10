// ignore_for_file: public_member_api_docs, sort_constructors_first

class NearestDriver {
  int? id;
  String? name;
  String? latitude;
  String? longitude;
  double? distance;
  String? imageForWeb;

  NearestDriver(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.distance,
      this.imageForWeb});

  @override
  bool operator ==(covariant NearestDriver other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.distance == distance &&
        other.imageForWeb == imageForWeb;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        distance.hashCode ^
        imageForWeb.hashCode;
  }
}
