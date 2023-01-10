import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/hold_message_with.dart';

abstract class RateServiceDataSource {
  Future<HoldMessageWith<Unit>> addRating({
    required String comment,
    required String orderId,
    required String token,
    required String rating,
  });
}

class RateServiceDataSourceImpl implements RateServiceDataSource {
  final http.Client client;
  RateServiceDataSourceImpl({required this.client});
  @override
  Future<HoldMessageWith<Unit>> addRating({
    required String comment,
    required String orderId,
    required String token,
    required String rating,
  }) async {
    try {
      final response = await client.post(Uri.parse(Urls.addRating),
          headers: Urls.getHeaders(token: token),
          body: {
            'order_id': orderId,
            'rating': rating,
            'type': "1",
            'comment': comment,
          });
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return HoldMessageWith<Unit>(
            data: unit, message: responseBody['message']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<HoldMessageWith<Unit>>().timeOutMethod(() =>
          addRating(
              comment: comment,
              orderId: orderId,
              token: token,
              rating: rating));
    } catch (error) {
      rethrow;
    }
  }
}
