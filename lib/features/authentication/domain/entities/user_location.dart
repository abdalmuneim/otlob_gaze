class UserLocation {
  int? id;
  String? lat;
  String? long;
  String? title;
  String? floorNumber;
  String? buildingNumber;
  bool? defaultLocation;

  UserLocation(
      {this.id,
      this.lat,
      this.long,
      this.title,
      this.floorNumber,
      this.buildingNumber,
      this.defaultLocation});

  @override
  bool operator ==(covariant UserLocation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lat == lat &&
        other.long == long &&
        other.title == title &&
        other.floorNumber == floorNumber &&
        other.buildingNumber == buildingNumber &&
        other.defaultLocation == defaultLocation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        title.hashCode ^
        floorNumber.hashCode ^
        buildingNumber.hashCode ^
        defaultLocation.hashCode;
  }

  UserLocation copyWith({
    int? id,
    String? lat,
    String? long,
    String? title,
    String? floorNumber,
    String? buildingNumber,
    bool? defaultLocation,
  }) {
    return UserLocation(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      title: title ?? this.title,
      floorNumber: floorNumber ?? this.floorNumber,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      defaultLocation: defaultLocation ?? this.defaultLocation,
    );
  }

  int orderByDefaultLocation(UserLocation other) {
    if (other.defaultLocation!) {
      return 1;
    } else {
      return -1;
    }
  }
}
