import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/providers/communication_provider.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/widgets/text_chat_widget.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/widgets/voice_chat_widget.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:otlob_gas/widget/shimmers/avatar_shimmer.dart';
import 'package:otlob_gas/widget/shimmers/text_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunicationWithTheDriver extends StatefulWidget {
  const CommunicationWithTheDriver({super.key, required this.orderId});
  final String orderId;

  @override
  State<CommunicationWithTheDriver> createState() =>
      _CommunicationWithTheDriverState();
}

class _CommunicationWithTheDriverState
    extends State<CommunicationWithTheDriver> {
  bool isLoading = true;
  late final CommunicationProvider communicationProvider =
      context.read<CommunicationProvider>();

  init() async {
    await communicationProvider.initChat(widget.orderId);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    communicationProvider.disconnectPusher();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        toolbarHeight: 130,
        leading: const SizedBox(),
        title: CustomText(
          Utils.localization?.communication_with_the_driver,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontSize: 25,
              ),
        ),
        bottomWidget: isLoading
            ? ListTile(
                leading: const AvatarShimmer(),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextShimmer(width: 100),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.locationOutlinedIC,
                      color: Colors.red,
                      height: 18,
                    ),
                    const SizedBox(width: 5.0),
                    const TextShimmer(width: 150),
                  ],
                ),
              )
            : ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  child: Image.asset(Assets.ambobaIC),
                ),
                title: CustomText(communicationProvider.chat.driver?.name),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.locationOutlinedIC,
                      color: Colors.red,
                      height: 18,
                    ),
                    const SizedBox(width: 5.0),
                    CustomText(communicationProvider.chat.driver?.address)
                  ],
                ),
                trailing: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (communicationProvider.chat.driver?.mobile == null) {
                      return;
                    }
                    launchUrl(Uri.parse(
                        "tel://${communicationProvider.chat.driver?.mobile}"));
                  },
                  icon: SvgPicture.asset(
                    communicationProvider.chat.driver?.mobile != null
                        ? Assets.callIC
                        : Assets.callNotActive,
                  ),
                ),
              ),
      ),
      body: isLoading
          ? const LoadingWidget()
          : Consumer<CommunicationProvider>(
              builder: (_, communicationProvider, __) => Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: communicationProvider.chat.messages.length,
                        itemBuilder: (context, index) {
                          final ChatMessage chatMessage =
                              communicationProvider.chat.messages[index];
                          final bool isCurrentChat = chatMessage.userId !=
                              communicationProvider.chat.driverId;

                          switch (chatMessage.type) {
                            case '0':
                              return VoiceChatWidget(
                                isCurrentChat: isCurrentChat,
                                messageStatus: chatMessage.messageStatus,
                                url:
                                    '${communicationProvider.chat.voiceUrl ?? ''}/${chatMessage.message ?? ''}',
                              );

                            default:
                              return TextChatWidget(
                                isCurrentChat: isCurrentChat,
                                text: chatMessage.message,
                                messageStatus: chatMessage.messageStatus,
                              );
                          }
                        },
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppColors.otherChat),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12),
                      child: Column(
                        children: [
                          Row(children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  IgnorePointer(
                                    ignoring: communicationProvider.isRecording,
                                    child: CustomTextField(
                                      hintText: communicationProvider
                                              .isRecording
                                          ? null
                                          : Utils.localization?.write_a_message,
                                      textEditingController:
                                          communicationProvider
                                              .messageController,
                                      onTap: () {
                                        communicationProvider.setEmojiShowing =
                                            false;
                                      },
                                      onChanged: (value) {
                                        communicationProvider.setMessage =
                                            value;
                                      },
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          communicationProvider
                                              .setEmojiShowing = true;
                                        },
                                        icon: const Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: AppColors.mainApp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (communicationProvider.isRecording)
                                    Positioned(
                                      bottom: 5,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: communicationProvider
                                                .deleteRecord,
                                            child: const CircleAvatar(
                                              radius: 19,
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.delete_outline_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          TweenAnimationBuilder<Duration>(
                                              duration:
                                                  const Duration(seconds: 60),
                                              tween: Tween(
                                                  begin: Duration.zero,
                                                  end: const Duration(
                                                      seconds: 60)),
                                              onEnd: () {
                                                communicationProvider
                                                    .stopRecorder();
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    '${minutes.getDurationReminder}:${seconds.getDurationReminder}',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: AppColors.mainApp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            if (communicationProvider.isTyping ||
                                communicationProvider.isRecording)
                              GestureDetector(
                                onTap: communicationProvider.isRecording
                                    ? communicationProvider.toggleRecorder
                                    : communicationProvider.sendMessage,
                                child: const CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: AppColors.sendCircle,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: communicationProvider.toggleRecorder,
                                child: SvgPicture.asset(
                                  Assets.recordIC,
                                  height: 45,
                                ),
                              )
                          ]),
                          const SizedBox(
                            height: 15,
                          ),
                          Consumer<CommunicationProvider>(
                              builder: (_, provider, __) {
                            return Offstage(
                              offstage: !provider.emojiShowing,
                              child: SizedBox(
                                height: 250,
                                child: EmojiPicker(
                                  onEmojiSelected:
                                      (Category? category, Emoji? emoji) {
                                    // Do something when emoji is tapped (optional)
                                  },
                                  onBackspacePressed: () {
                                    // Do something when the user taps the backspace button (optional)
                                  },
                                  textEditingController: communicationProvider
                                      .messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                                  config: Config(
                                    columns: 7,
                                    emojiSizeMax: 32 *
                                        (foundation.defaultTargetPlatform ==
                                                TargetPlatform.iOS
                                            ? 1.30
                                            : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    gridPadding: EdgeInsets.zero,
                                    initCategory: Category.RECENT,
                                    bgColor: Colors.white,
                                    indicatorColor: Colors.blue,
                                    iconColor: Colors.grey,
                                    iconColorSelected: Colors.blue,
                                    backspaceColor: Colors.blue,
                                    skinToneDialogBgColor: Colors.white,
                                    skinToneIndicatorColor: Colors.white,
                                    enableSkinTones: true,
                                    showRecentsTab: true,
                                    recentsLimit: 28,
                                    noRecents: const Text(
                                      'No Recents',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                      textAlign: TextAlign.center,
                                    ), // Needs to be const Widget
                                    loadingIndicator: const SizedBox
                                        .shrink(), // Needs to be const Widget
                                    tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
