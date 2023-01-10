import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';

class User {
  final int? id;
  final String? name;
  final String? email;
  // final Null? emailVerifiedAt;
  final String? mobile;
  final String? image;
  final String? imageForWeb;
  final int? isActive;
  final int? status;
  // final Null? driverPaper;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final double? wallet;
  final double? rating;
  final UserLocation? location;
  const User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.location,
      this.address,
      this.image,
      this.imageForWeb,
      this.isActive,
      this.rating,
      this.wallet,
      this.status,
      this.createdAt,
      this.updatedAt});

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.mobile == mobile &&
        other.image == image &&
        other.imageForWeb == imageForWeb &&
        other.isActive == isActive &&
        other.status == status &&
        other.address == address &&
        other.rating == rating &&
        other.wallet == wallet &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        image.hashCode ^
        imageForWeb.hashCode ^
        isActive.hashCode ^
        wallet.hashCode ^
        rating.hashCode ^
        status.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        location.hashCode;
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? mobile,
    String? image,
    String? imageForWeb,
    double? wallet,
    double? rating,
    int? isActive,
    int? status,
    String? address,
    String? createdAt,
    String? updatedAt,
    UserLocation? location,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      imageForWeb: imageForWeb ?? this.imageForWeb,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      wallet: wallet ?? this.wallet,
    );
  }
}
