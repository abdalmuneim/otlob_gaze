// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.mobile,
    super.image,
    super.isActive,
    super.imageForWeb,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.address,
    this.password,
    this.confirmPassword,
    this.token,
    super.location,
    super.rating,
    super.wallet,
  });

  final String? token;
  final String? password;
  final String? confirmPassword;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']),
        token: json['token'],
        name: json['name'],
        email: json['email'],
        mobile: json['mobile'],
        image: json['image'],
        imageForWeb: json['image_for_web'],
        isActive: json['is_active'] is int
            ? json['is_active']
            : int.tryParse(json['is_active']),
        status: json['status'] is int
            ? json['status']
            : int.tryParse(json['status']),
        location: json['location'] != null
            ? (json['location'] is String
                ? UserLocationModel.fromJson(json['location'])
                : UserLocationModel.fromMap(json['location']))
            : null,
        address: json['address'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        wallet: double.tryParse(json['wallet'].toString()) ?? 0,
        rating: double.tryParse(json['rating'].toString()) ?? 0,
      );

  Map<String, String> toMap() => {
        'type': '1',
        if (id != null) "id": id.toString(),
        if (password != null && password!.isNotEmpty) "password": password!,
        if (confirmPassword != null && confirmPassword!.isNotEmpty)
          "password_confirmation": confirmPassword!,
        if (name != null && name!.isNotEmpty) 'name': name!,
        if (email != null && email!.isNotEmpty) 'email': email!,
        if (mobile != null && mobile!.isNotEmpty) 'mobile': mobile!,
        if (imageForWeb != null && imageForWeb!.isNotEmpty)
          'image_for_web': imageForWeb!,
        if (image != null && image!.isNotEmpty) 'image': image!,
        if (isActive != null) 'is_active': "$isActive",
        if (status != null) 'status': '$status',
        if (location?.lat != null && location!.lat!.isNotEmpty)
          'lat': location!.lat!,
        if (location?.long != null && location!.long!.isNotEmpty)
          'long': location!.long!,

        if (location != null)
          'location': (location as UserLocationModel).toJson(),
        // if(driverPaper!=null&&driverPaper!.isNotEmpty)'driver_paper': this.driverPaper,
        if (address != null && address!.isNotEmpty) 'address': address!,
        if (wallet != null) 'wallet': wallet!.toString(),
        if (rating != null) 'rating': rating!.toString(),
      };

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
