import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/features/communication_with_the_driver/presentation/widgets/chat_holder_widget.dart';

class VoiceChatWidget extends StatefulWidget {
  const VoiceChatWidget({
    Key? key,
    required this.url,
    required this.isCurrentChat,
    required this.messageStatus,
  }) : super(key: key);

  final String url;
  final int? messageStatus;
  final bool isCurrentChat;

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget>
    with AutomaticKeepAliveClientMixin {
  final AudioPlayer player = AudioPlayer();
  Duration? get duration => _duration;
  int get durationInSeconds => duration?.inSeconds ?? 0;
  int get durationInMinutes => duration?.inMinutes ?? 0;
  String get getPositionProgress =>
      '${position.inMinutes.getDurationReminder}:${position.inSeconds.remainder(60).getDurationReminder}';
  String get getDurationProgress =>
      '${durationInMinutes.getDurationReminder}:${durationInSeconds.remainder(60).getDurationReminder}';

  Duration _position = const Duration();
  Duration _duration = const Duration();
  bool _isPlaying = false;

  initPlayer() async {
    player.setSourceUrl(widget.url);
    player.onPositionChanged.listen((event) {
      _position = event;
      if (mounted) {
        setState(() {});
      }
    });
    player.onDurationChanged.listen((event) {
      _duration = event;
      if (mounted) {
        setState(() {});
      }
    });
    player.onPlayerStateChanged.listen((event) {
      _isPlaying = event == PlayerState.playing;
      if (mounted) {
        setState(() {});
      }
    });
    player.onPlayerComplete.listen((event) {
      _position = const Duration(seconds: 0);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  initState() {
    initPlayer();
    super.initState();
  }

  @override
  dispose() {
    player.dispose();
    super.dispose();
  }

  play() async {
    player.play(UrlSource(widget.url));
  }

  pause() async {
    await player.pause();
  }

  seekTo(Duration value) async {
    await player.seek(value);
  }

  Duration get position => _position;
  togglePlayer() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChatHolderWidget(
      isCurrentChat: widget.isCurrentChat,
      messageStatus: widget.messageStatus,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: togglePlayer,
            child: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 35,
              color: AppColors.mainApp,
            ),
          ),
          Text(
            getPositionProgress,
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
          ),
          Expanded(
            child: Slider(
              activeColor: AppColors.mainApp,
              inactiveColor: Colors.black26,
              thumbColor: Colors.white,
              min: 0,
              max: duration?.inSeconds.toDouble() ?? 0.0,
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                seekTo(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Text(
            getDurationProgress,
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
