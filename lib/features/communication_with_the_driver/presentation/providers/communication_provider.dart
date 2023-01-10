import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/disconnect_chat_pusher_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/get_chat_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/init_chat_pusher_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/listen_to_chat_use_case.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/usecases/send_message_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class CommunicationProvider extends ChangeNotifier {
  final GetChatUseCase _getChatUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final InitChatPusherUseCase _initPusherUseCase;
  final DisconnectChatPusherUseCase _disconnectPusherUseCase;
  final ListenToChatUseCase _listenToChatUseCase;
  TextEditingController messageController = TextEditingController();
  bool emojiShowing = false;

  set setEmojiShowing(bool value) {
    if (value != emojiShowing) {
      emojiShowing = value;
      notifyListeners();
    }
  }

  CommunicationProvider(
      this._getChatUseCase,
      this._sendMessageUseCase,
      this._initPusherUseCase,
      this._disconnectPusherUseCase,
      this._listenToChatUseCase);

  late Chat chat;
  BuildContext get context => NavigationService.context;

  String message = '';

  set setMessage(String message) {
    final bool isNotify = this.message.isEmpty || message.isEmpty;
    this.message = message;
    if (isNotify) {
      notifyListeners();
    }
  }

  bool get isTyping {
    return message.isNotEmpty;
  }

  File? voiceFile;

  final Record record = Record();
  bool isRecording = false;

  Future<void> stopRecorder() async {
    await record.stop();
    isRecording = false;
    notifyListeners();
    sendMessage();
  }

// method to empty voice file
  deleteMedia() {
    voiceFile = null;
    notifyListeners();
  }

// method to stop record
  deleteRecord() async {
    await record.stop();
    isRecording = false;
    deleteMedia();
  }

// start record if is not recording and stop it then send message if is recording
  Future<void> toggleRecorder() async {
    if (isRecording) {
      stopRecorder();
    } else {
      startRecord();
    }
  }

// method to start recording
  void startRecord() async {
    await openTheRecorder();
    String uniqueKey = const Uuid().v4() +
        DateTime.now().toIso8601String().replaceAll('.', '-');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    voiceFile = File('$tempPath/$uniqueKey.m4a');

    record.start(path: voiceFile!.path).then((value) {
      isRecording = true;
      notifyListeners();
    }).onError((error, stackTrace) {
      isRecording = false;
    });
  }

// method to ask recording permissions
  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted && await record.hasPermission()) {
        throw Exception('Microphone permission not granted');
      }
    } else {
      throw Exception(
          'communication_provider.dart =====> openTheRecorder error =======> Microphone permission not available for web');
    }
  }

  late String orderId;
// init chat page
  Future<void> initChat(String orderId) async {
    this.orderId = orderId;
    message = '';
    messageController.clear();
    voiceFile = null;
    final result = await _getChatUseCase(orderId: orderId);
    result.fold((failure) => Utils.handleFailures(failure), (myChat) async {
      final List<ChatMessage> chatMessages = List.from(myChat.messages);
      chat = myChat.copyWith(messages: chatMessages.reversed.toList());
      await _initPusherUseCase(orderId: chat.orderId!);
      listenToChat();
    });
  }

// send message to backend
  Future<void> sendMessage() async {
    if (message.isEmpty && voiceFile == null) {
      return;
    }
    //set message type to 1 if text and 0 if voice
    String messageType = '1';
    //set voice file path to message
    if (voiceFile != null) {
      message = voiceFile!.path;
      messageType = '0';
      voiceFile = null;
    }
    final ChatMessage chatMessage = ChatMessage(
        message: message,
        id: const Uuid().v4(),
        type: messageType,
        userId: chat.customerId);
    if (messageType == '1') {
      insertMessageToFirst(chatMessage);
    }
    setMessage = '';
    messageController.clear();
    final result = await _sendMessageUseCase(
        messageId: chatMessage.id!,
        orderId: orderId,
        message: chatMessage.message!,
        type: messageType);
    result.fold((failure) {
      Utils.handleFailures(failure);
      chat = chat
        ..messages
            .firstWhere((element) => element == chatMessage)
            .messageStatus = 0;
    }, (chatMessage) {});
  }

// disconnect pusher
  disconnectPusher() {
    _disconnectPusherUseCase();
  }

// listen to chat message stream
  void listenToChat() {
    _listenToChatUseCase().listen((chatMessage) {
      if (chatMessage.userId == chat.customerId) {
        final int index =
            chat.messages.indexWhere((element) => element.id == chatMessage.id);
        if (index != -1) {
          chat.messages[index] = chatMessage;
        } else {
          insertMessageToFirst(chatMessage);
        }
      } else {
        insertMessageToFirst(chatMessage);
      }
      notifyListeners();
    });
  }

  insertMessageToFirst(ChatMessage chatMessage) {
    chat.messages.insert(0, chatMessage);
  }
}
