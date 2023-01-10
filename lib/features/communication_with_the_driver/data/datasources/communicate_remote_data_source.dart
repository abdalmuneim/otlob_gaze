import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/models/chat_message_model.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/models/chat_model.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

abstract class CommunicationRemoteDataSource {
  Future<ChatMessageModel> sendMessage({
    required String message,
    required String orderId,
    required String messageId,
    required String type,
    required String token,
  });

  Future<ChatModel> getChat({
    required String orderId,
    required String token,
  });
  Future<Unit> initPusher({required int orderId});
  Stream<ChatMessageModel> listenToChat();
  Future<Unit> disconnectPusher();
}

class CommunicationRemoteDataSourceImpl
    implements CommunicationRemoteDataSource {
  final http.Client client;
  final PusherChannelsFlutter pusher;
  StreamController<ChatMessageModel>? _streamController;
  CommunicationRemoteDataSourceImpl(
      {required this.pusher, required this.client});

  @override
  Future<ChatMessageModel> sendMessage({
    required String message,
    required String type,
    required String orderId,
    required String messageId,
    required String token,
  }) async {
    try {
      final ChatMessageModel chatMessageModel = ChatMessageModel(
        type: type,
        id: messageId,
      );
      late final dynamic response;
      late final Map<String, dynamic> responseBody;
      if (type == '1') {
        chatMessageModel.message = message;
        response = await client.post(Uri.parse(Urls.chat()),
            headers: Urls.getHeaders(token: token),
            body: chatMessageModel.toMap()..addAll({'order_id': orderId}));
        responseBody = json.decode(response.body);
      } else {
        final http.MultipartRequest request =
            http.MultipartRequest('POST', Uri.parse(Urls.chat()));
        request.fields
            .addAll(chatMessageModel.toMap()..addAll({'order_id': orderId}));

        request.files
            .add(await http.MultipartFile.fromPath('message', message));

        request.headers.addAll(Urls.getHeaders(token: token));
        response = await request.send();
        responseBody = json.decode(await response.stream.bytesToString());
      }

      if (response.statusCode == Strings.successStatusCode) {
        return ChatMessageModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<ChatMessageModel>().timeOutMethod(() => sendMessage(
            message: message,
            type: type,
            orderId: orderId,
            token: token,
            messageId: messageId,
          ));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ChatModel> getChat({
    required String orderId,
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.chat(orderId: orderId)),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return ChatModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<ChatModel>()
          .timeOutMethod(() => getChat(orderId: orderId, token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> initPusher({required int orderId}) async {
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
        onEvent: listenToEvent,
      );
      // subscribe to channel
      await pusher.subscribe(channelName: Strings.getChatChannel(orderId));
      // connect to channel
      await pusher.connect();

      return unit;
    } on SocketException {
      return ServerService<Unit>()
          .timeOutMethod(() => initPusher(orderId: orderId));
    } catch (error) {
      rethrow;
    }
  }

// Bind to listen for events called "chat"
  listenToEvent(PusherEvent event) {
    final responseBody = jsonDecode(event.data);
    final ChatMessageModel chatMessageModel =
        ChatMessageModel.fromMap(responseBody['Data']);
    _streamController!.add(chatMessageModel);
  }

// listen chat message model from pusher
  @override
  Stream<ChatMessageModel> listenToChat() {
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
