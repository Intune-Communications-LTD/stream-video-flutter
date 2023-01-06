import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbtwirp.dart'
    as signal_twirp;
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/v2/sfu/sfu_client.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/utils/result_converters.dart';
import 'package:tart/tart.dart';

/// TODO
class SfuClientImpl extends SfuClient {
  /// TODO
  SfuClientImpl({
    required String baseUrl,
    required this.authToken,
    String prefix = '',
    ClientHooks? hooks,
    List<Interceptor> interceptors = const [],
  }) : _client = signal_twirp.SignalServerProtobufClient(
          baseUrl,
          prefix,
          hooks: hooks,
          interceptor: chainInterceptor(interceptors),
        );

  final _logger = taggedLogger(tag: 'SV:SfuClient');

  /// TODO
  final String authToken;

  final signal_twirp.SignalServerProtobufClient _client;

  @override
  Future<Result<sfu.SendAnswerResponse>> sendAnswer(
    sfu.SendAnswerRequest request,
  ) async {
    try {
      final result = await _client.sendAnswer(_withAuthHeaders(), request);
      return result.asSuccess();
    } catch (e, stk) {
      return e.asFailure(stk);
    }
  }

  @override
  Future<Result<sfu.ICETrickleResponse>> sendIceCandidate(
    sfu_models.ICETrickle request,
  ) async {
    try {
      final result = await _client.iceTrickle(_withAuthHeaders(), request);
      return result.asSuccess();
    } catch (e, stk) {
      return e.asFailure(stk);
    }
  }

  @override
  Future<Result<sfu.SetPublisherResponse>> setPublisher(
    sfu.SetPublisherRequest request,
  ) async {
    try {
      final result = await _client.setPublisher(_withAuthHeaders(), request);
      return result.asSuccess();
    } catch (e, stk) {
      return e.asFailure(stk);
    }
  }

  @override
  Future<Result<sfu.UpdateMuteStatesResponse>> updateMuteState(
    sfu.UpdateMuteStatesRequest request,
  ) async {
    try {
      final result = await _client.updateMuteStates(
        _withAuthHeaders(),
        request,
      );
      return result.asSuccess();
    } catch (e, stk) {
      return e.asFailure(stk);
    }
  }

  @override
  Future<Result<sfu.UpdateSubscriptionsResponse>> updateSubscriptions(
    sfu.UpdateSubscriptionsRequest request,
  ) async {
    try {
      final result = await _client.updateSubscriptions(
        _withAuthHeaders(),
        request,
      );
      return result.asSuccess();
    } catch (e, stk) {
      return e.asFailure(stk);
    }
  }

  Context _withAuthHeaders([Context? ctx]) {
    ctx ??= Context();
    return withHttpRequestHeaders(ctx, {
      'Authorization': 'Bearer $authToken',
    });
  }
}
