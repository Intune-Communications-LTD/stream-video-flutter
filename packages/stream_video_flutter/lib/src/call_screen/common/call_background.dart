import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Renders a call background that shows either a static image or user images
/// based on the call state.
class CallBackground extends StatelessWidget {
  /// Creates a new instance of [CallBackground].
  const CallBackground({
    super.key,
    required this.participants,
    this.child,
  });

  /// The child widget.
  final Widget? child;

  /// The list of participants in the call.
  final List<UserInfo> participants;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (participants.length == 1)
          _ParticipantImageBackground(
            imageUrl: participants.first.image,
          )
        else
          const CustomOutgoingBackground(),
        child ?? const SizedBox(),
      ],
    );
  }
}

class _ParticipantImageBackground extends StatelessWidget {
  const _ParticipantImageBackground({
    required this.imageUrl,
  });

  /// The URL of the image.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final overlayColor = streamChatTheme.colorTheme.overlay;
    final hasImage = imageUrl?.isNotEmpty ?? false;

    if (hasImage) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            imageUrl: imageUrl!,
            errorWidget: (_, __, ___) => const CustomOutgoingBackground(),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: ColoredBox(
                color: overlayColor,
              ),
            ),
          ),
        ],
      );
    } else {
      return const CustomOutgoingBackground();
    }
  }
}

// class _DefaultCallBackground extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: BoxFit.fill,
//       child: Image.asset(
//         'images/call_background.jpg',
//         package: 'stream_video_flutter',
//       ),
//     );
//   }
// }

class CustomOutgoingBackground extends StatelessWidget {
  const CustomOutgoingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = StreamVideoTheme.of(context);

    return Container(
      color: Colors.black,
    );
  }
}
