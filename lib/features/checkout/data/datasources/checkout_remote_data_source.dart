import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/features/checkout/data/models/order_model.dart';
import 'package:otlob_gas/features/checkout/data/models/real_time_order_model.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

abstract class CheckoutRemoteDataSource {
  Future<Unit> cancelOrder({
    required String token,
    required int orderId,
  });
  Future<OrderModel> createOrder({
    required String token,
    required int locationId,
  });
  Future<Unit> deliveredCheck({
    required String token,
    required int orderId,
  });
  Future<Unit> deliveredUnCheck({
    required String token,
    required int orderId,
  });
  Future<Unit> orderDelivered({
    required String token,
    required int orderId,
  });
  Future<OrderModel> assignOrder({
    required String token,
    required String notes,
    required int paymentMethod,
    required int quantity,
    required int orderId,
  });
  Future<List<OrderModel>> getOrders({required String token});

  Stream<RealTimeOrderModel> listenToCheckout();
  Future<Unit> initPusher({required int driverId, required int customerId});
  Future<Unit> disconnectPusher();
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final http.Client client;
  final PusherChannelsFlutter pusher;
  StreamController<RealTimeOrderModel>? _streamController;
  CheckoutRemoteDataSourceImpl({required this.pusher, required this.client});

  @override
  Future<Unit> cancelOrder({
    required int orderId,
    required String token,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.cancelOrder(orderId)),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>()
          .timeOutMethod(() => cancelOrder(orderId: orderId, token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<OrderModel> createOrder(
      {required String token, required int locationId}) async {
    try {
      final response = await client.post(Uri.parse(Urls.createOrder),
          headers: Urls.getHeaders(token: token),
          body: {"location_id": locationId.toString()});
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return OrderModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<OrderModel>().timeOutMethod(
          () => createOrder(token: token, locationId: locationId));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> deliveredCheck(
      {required String token, required int orderId}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.deliveredCheck(orderId: orderId)),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>()
          .timeOutMethod(() => deliveredCheck(token: token, orderId: orderId));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> deliveredUnCheck(
      {required String token, required int orderId}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.deliveredUnCheck(orderId: orderId)),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>().timeOutMethod(
          () => deliveredUnCheck(token: token, orderId: orderId));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> orderDelivered(
      {required String token, required int orderId}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.orderDelivered(orderId: orderId)),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>()
          .timeOutMethod(() => orderDelivered(token: token, orderId: orderId));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<OrderModel> assignOrder({
    required String token,
    required String notes,
    required int paymentMethod,
    required int quantity,
    required int orderId,
  }) async {
    try {
      final response = await client.post(
          Uri.parse(Urls.assignOrder(orderId: orderId)),
          headers: Urls.getHeaders(token: token),
          body: {
            "notes": notes,
            'payment_method': paymentMethod.toString(),
            'quantity': quantity.toString(),
          });
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return OrderModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<OrderModel>().timeOutMethod(
        () => assignOrder(
          token: token,
          notes: notes,
          paymentMethod: paymentMethod,
          quantity: quantity,
          orderId: orderId,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrders({required String token}) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.order),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        List<OrderModel> orders = [];

        for (var element in responseBody['data']) {
          orders.add(OrderModel.fromMap(element));
        }
        return orders;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<OrderModel>>()
          .timeOutMethod(() => getOrders(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> initPusher(
      {required int driverId, required int customerId}) async {
    try {
      //init Stream
      if (_streamController == null ||
          _streamController!.isClosed ||
          _streamController!.isPaused) {
        _streamController = StreamController();
      }
      // init pusher
      await pusher.init(
        apiKey: Strings.pusherAppKey,
        cluster: Strings.pusherCluster,
        onError: (message, code, error) {
          if (kDebugMode) {
            print(['message $message', 'code $code', 'error $error']);
          }
        },
        onEvent: (event) => listenToEvent(event, customerId),
      );
      // subscribe to channel
      await pusher.subscribe(
          channelName: Strings.getDriverChannel(driverId: driverId));
      // connect to channel
      await pusher.connect();

      return unit;
    } on SocketException {
      return ServerService<Unit>().timeOutMethod(
          () => initPusher(driverId: driverId, customerId: customerId));
    } catch (error) {
      rethrow;
    }
  }

// Bind to listen for events called "driver"
  listenToEvent(PusherEvent event, int userId) {
    final responseBody = jsonDecode(event.data);
    final RealTimeOrderModel realTimeOrderModel =
        RealTimeOrderModel.fromMap(responseBody['Data']);

    if (realTimeOrderModel.order?.customerId == userId ||
        realTimeOrderModel.order == null) {
      _streamController!.add(realTimeOrderModel);
    }
  }

// listen chat message model from pusher
  @override
  Stream<RealTimeOrderModel> listenToCheckout() {
    return _streamController!.stream;
  }

// Disconnect from pusher service
  @override
  Future<Unit> disconnectPusher() async {
    try {
      pusher.disconnect();
      _streamController!.close();
      return unit;
    } on SocketException {
      return ServerService<Unit>().timeOutMethod(() => disconnectPusher());
    } catch (error) {
      rethrow;
    }
  }
}
