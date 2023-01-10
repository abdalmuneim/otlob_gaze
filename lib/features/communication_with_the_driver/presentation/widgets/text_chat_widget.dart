import 'package:flutter/material.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/widgets/chat_holder_widget.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class TextChatWidget extends StatelessWidget {
  const TextChatWidget(
      {super.key,
      required this.isCurrentChat,
      required this.text,
      required this.messageStatus});
  final bool isCurrentChat;
  final String? text;
  final int? messageStatus;
  @override
  Widget build(BuildContext context) {
    final bool isTextRTL = Utils.getDirection(text ?? '') == TextDirection.rtl;

    return ChatHolderWidget(
      messageStatus: messageStatus,
      isCurrentChat: isCurrentChat,
      child: CustomText(text ?? '',
          textAlign: Utils.isRTL
              ? isTextRTL
                  ? TextAlign.start
                  : TextAlign.end
              : isTextRTL
                  ? TextAlign.end
                  : TextAlign.start),
    );
  }
}
