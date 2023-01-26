import '../errors/video_error.dart';
import '../model/call_created.dart';
import '../model/call_joined.dart';
import 'action.dart';

abstract class LifecycleAction extends StreamAction {
  const LifecycleAction();
}

class CallUserIdAction extends LifecycleAction {
  const CallUserIdAction({
    required this.userId,
  });

  final String userId;
}

class CallDestroyedAction extends LifecycleAction {
  const CallDestroyedAction();
}

class CallCreatedAction extends LifecycleAction {
  const CallCreatedAction({
    required this.data,
  });

  final CallCreated data;
}

class CallAcceptedAction extends LifecycleAction {
  const CallAcceptedAction();
}

class CallRejectedAction extends LifecycleAction {
  const CallRejectedAction();
}

class CallCancelledAction extends LifecycleAction {
  const CallCancelledAction();
}

class CallJoinedAction extends LifecycleAction {
  const CallJoinedAction(this.data);

  final CallJoined data;
}

class CallSessionStartAction extends LifecycleAction {
  const CallSessionStartAction({required this.sessionId});

  final String sessionId;
}

class CallConnectedAction extends LifecycleAction {
  const CallConnectedAction();
}

class CallTimeoutAction extends LifecycleAction {
  const CallTimeoutAction(this.timeLimit);
  final Duration timeLimit;
}

class CallConnectFailedAction extends LifecycleAction {
  const CallConnectFailedAction(this.error);
  final VideoError error;
}