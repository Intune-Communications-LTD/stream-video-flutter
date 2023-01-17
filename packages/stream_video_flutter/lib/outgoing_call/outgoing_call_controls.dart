import 'package:flutter/material.dart';

import '../stream_video_flutter.dart';

/// Represents a set of controls the user can use on the calling screen
/// to cancel the call, toggle their audio and video state.
class OutgoingCallControls extends StatelessWidget {
  const OutgoingCallControls({
    super.key,
    required this.onHangup,
    this.isMicrophoneEnabled = false,
    this.isCameraEnabled = false,
  });

  /// The action to perform when the hang up button is tapped.
  final VoidCallback onHangup;

  /// If camera is enabled.
  final bool isCameraEnabled;

  /// If microphone is enabled.
  final bool isMicrophoneEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        children: [
          CallControlOption(
            icon: const Icon(Icons.call_rounded),
            iconColor: Colors.white,
            backgroundColor: Colors.red,
            onPressed: onHangup,
            padding: const EdgeInsets.all(24),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CallControlOption(
                icon: isMicrophoneEnabled
                    ? const Icon(Icons.mic_rounded)
                    : const Icon(Icons.mic_off_rounded),
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  // TODO: Hande the action
                },
              ),
              CallControlOption(
                icon: isCameraEnabled
                    ? const Icon(Icons.videocam_rounded)
                    : const Icon(Icons.videocam_off_rounded),
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  // TODO: Hande the action
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
