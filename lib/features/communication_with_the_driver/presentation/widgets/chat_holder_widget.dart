import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';

class ChatHolderWidget extends StatelessWidget {
  const ChatHolderWidget(
      {super.key,
      required this.isCurrentChat,
      required this.child,
      required this.messageStatus});
  final bool isCurrentChat;
  final Widget child;
  final int? messageStatus;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isCurrentChat ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:
                      isCurrentChat ? const Radius.circular(12) : Radius.zero,
                  topRight:
                      !isCurrentChat ? const Radius.circular(12) : Radius.zero,
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
                color: isCurrentChat ? AppColors.myChat : AppColors.otherChat),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  minWidth: 50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                    if (isCurrentChat)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (messageStatus == null)
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 15,
                              color: Colors.grey,
                            )
                          else if (messageStatus == 0)
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 15,
                            )
                          else
                            const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
