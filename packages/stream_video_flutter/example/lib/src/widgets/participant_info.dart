import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class ParticipantTrack {
  ParticipantTrack({
    required this.participant,
    required this.videoTrack,
    required this.isScreenShare,
  });

  final VideoTrack? videoTrack;
  final Participant participant;
  final bool isScreenShare;
}

class ParticipantInfoWidget extends StatelessWidget {
  const ParticipantInfoWidget({
    this.title,
    this.audioAvailable = true,
    this.connectionQuality = ConnectionQuality.unknown,
    this.isScreenShare = false,
    Key? key,
  }) : super(key: key);

  final String? title;
  final bool audioAvailable;
  final ConnectionQuality connectionQuality;
  final bool isScreenShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Flexible(
              child: Text(
                title!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          isScreenShare
              ? const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.monitor,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    audioAvailable ? Icons.mic : Icons.mic_off,
                    color: audioAvailable ? Colors.white : Colors.red,
                    size: 16,
                  ),
                ),
          if (connectionQuality != ConnectionQuality.unknown)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                connectionQuality == ConnectionQuality.poor
                    ? Icons.wifi_off_rounded
                    : Icons.wifi_rounded,
                color: {
                  ConnectionQuality.excellent: Colors.green,
                  ConnectionQuality.good: Colors.orange,
                  ConnectionQuality.poor: Colors.red,
                }[connectionQuality],
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}