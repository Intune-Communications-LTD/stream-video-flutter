import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'regular_call_participants_content.dart';
import 'screen_share_call_participants_content.dart';

/// Builder function used to build a participant item.
typedef CallParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build a screen sharing content.
typedef ScreenShareContentBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build participant item in screen sharing mode.
typedef ScreenShareParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// A function used to sort the participants.
typedef Filter<T> = bool Function(T element);

/// Comparator used to sort the participants.
typedef Sort<T> = Comparator<T>;

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatefulWidget {
  /// Creates a new instance of [StreamCallParticipant].
  StreamCallParticipants({
    super.key,
    required this.call,
    required this.participants,
    this.filter = _defaultFilter,
    Sort<CallParticipantState>? sort,
    this.enableLocalVideo,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.localVideoParticipantBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder = _defaultParticipantBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
  }) : sort = sort ?? layoutMode.sorting;

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Used for filtering the call participants.
  final Filter<CallParticipantState> filter;

  /// Used for sorting the call participants.
  final Sort<CallParticipantState> sort;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build a local video participant widget.
  final CallParticipantBuilder? localVideoParticipantBuilder;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder screenShareParticipantBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  // The default participant filter.
  static bool _defaultFilter(CallParticipantState participant) => true;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamCallParticipant(
      // We use the sessionId as the key to map the state to the participant.
      key: Key(participant.sessionId),
      call: call,
      participant: participant,
    );
  }

  @override
  State<StreamCallParticipants> createState() => _StreamCallParticipantsState();
}

class _StreamCallParticipantsState extends State<StreamCallParticipants> {
  List<CallParticipantState> _participants = [];
  CallParticipantState? _screenShareParticipant;

  @override
  void initState() {
    _recalculateParticipants();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StreamCallParticipants oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!const ListEquality<CallParticipantState>().equals(
        widget.participants.toList(), oldWidget.participants.toList())) {
      _recalculateParticipants();
    }
  }

  void _recalculateParticipants() {
    final participants = [...widget.participants].where(widget.filter).toList();
    mergeSort(participants, compare: widget.sort);

    final screenShareParticipant = participants.firstWhereOrNull(
      (it) {
        final screenShareTrack = it.screenShareTrack;
        final isScreenShareEnabled = it.isScreenShareEnabled;

        // If the screen share track is local, we don't have to subscribe to
        // anything and we can directly use the mute state.
        if (screenShareTrack is! RemoteTrackState) return isScreenShareEnabled;

        // If the screen share track is remote and already subscribed and
        // received, we can directly use the mute state.
        if (screenShareTrack.subscribed && screenShareTrack.received) {
          return isScreenShareEnabled;
        }

        // If it's not yet subscribed, we have to show it in order for it to
        // start the subscription process.
        return true;
      },
    );

    if (mounted) {
      setState(() {
        _participants = participants.toList();
        _screenShareParticipant = screenShareParticipant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screenShareParticipant != null) {
      return ScreenShareCallParticipantsContent(
        call: widget.call,
        participants: _participants,
        screenSharingParticipant: _screenShareParticipant!,
        screenShareContentBuilder: widget.screenShareContentBuilder,
        screenShareParticipantBuilder: widget.screenShareParticipantBuilder,
      );
    }

    return RegularCallParticipantsContent(
      call: widget.call,
      participants: _participants,
      layoutMode: widget.layoutMode,
      enableLocalVideo: widget.enableLocalVideo,
      callParticipantBuilder: widget.callParticipantBuilder,
      localVideoParticipantBuilder: widget.localVideoParticipantBuilder,
    );
  }
}
