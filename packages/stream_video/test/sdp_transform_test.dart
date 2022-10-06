// ignore_for_file: unnecessary_string_escapes

import 'dart:convert';

import 'package:stream_video/src/sdp-transform/models.dart';
import 'package:stream_video/src/sdp-transform/parse.dart';
import 'package:stream_video/src/sdp-transform/utils.dart';
import 'package:test/test.dart';

void main() {
  test('splitAt', () {
    final list = [
      'v',
      'o',
      's',
      't',
      'c',
      'a',
      'a',
      'a',
      'm',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'm',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a'
    ];
    expect([
      ['v', 'o', 's', 't', 'c', 'a', 'a', 'a'],
      ['m', 'a', 'a', 'a', 'a', 'a', 'a'],
      ['m', 'a', 'a', 'a', 'a', 'a', 'a']
    ], splitAt(list, [8, 15]));
  });

  test('mediaIndexes', () {
    final list = [
      'v',
      'o',
      's',
      't',
      'c',
      'a',
      'a',
      'a',
      'm=audio 54400 RTP/SAVPF 0 96',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'm=video 55400 RTP/SAVPF 97 98',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a'
    ];

    expect(mediaIndexes(list), [8, 15]);
  });

  test('Parse SDP', () {
    // ignore: leading_newlines_in_multiline_strings
    const sdpStr = '''v=0\r\n\
o=- 20518 0 IN IP4 203.0.113.1\r\n\
s= \r\n\
t=0 0\r\n\
c=IN IP4 203.0.113.1\r\n\
a=ice-ufrag:F7gI\r\n\
a=ice-pwd:x9cml/YzichV2+XlhiMu8g\r\n\
a=fingerprint:sha-1 42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7\r\n\
m=audio 54400 RTP/SAVPF 0 96\r\n\
a=rtpmap:0 PCMU/8000\r\n\
a=rtpmap:96 opus/48000\r\n\
a=ptime:20\r\n\
a=sendrecv\r\n\
a=candidate:0 1 UDP 2113667327 203.0.113.1 54400 typ host\r\n\
a=candidate:1 2 UDP 2113667326 203.0.113.1 54401 typ host\r\n\
m=video 55400 RTP/SAVPF 97 98\r\n\
a=rtpmap:97 H264/90000\r\n\
a=fmtp:97 profile-level-id=4d0028;packetization-mode=1\r\n\
a=rtpmap:98 VP8/90000\r\n\
a=sendrecv\r\n\
a=candidate:0 1 UDP 2113667327 203.0.113.1 55400 typ host\r\n\
a=candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host\r\n\
''';
    final sdp = parseSdp(sdpStr);

    final expectedSdp = Sdp(
        version: 0,
        origin: Origin(
            username: '-',
            sessionId: 20518,
            sessionVersion: 0,
            netType: 'IN',
            ipVer: 4,
            address: '203.0.113.1'),
        name: ' ',
        timing: Timing(start: 0, stop: 0),
        connection: Connection(version: 4, ip: '203.0.113.1'),
        iceUfrag: 'F7gI',
        icePwd: 'x9cml/YzichV2+XlhiMu8g',
        fingerprint: Fingerprint(
            type: 'sha-1',
            hash:
                '42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7'),
        media: [
          Media(
              rtp: [
                Rtp(payload: 96, codec: 'H264', rate: 48000),
                Rtp(payload: 0, codec: 'H264', rate: 8000)
              ],
              type: 'audio',
              port: 54400,
              protocol: 'RTP/SAVPF',
              payloads: '0 96',
              direction: 'sendrecv',
              candidates: [
                Candidate(
                    foundation: 1,
                    component: 2,
                    transport: 'UDP',
                    priority: 2113667326,
                    ip: '203.0.113.1',
                    port: 54401,
                    type: 'host'),
                Candidate(
                    foundation: 0,
                    component: 1,
                    transport: 'UDP',
                    priority: 2113667327,
                    ip: '203.0.113.1',
                    port: 54400,
                    type: 'host')
              ]),
          Media(
              rtp: [
                Rtp(payload: 98, codec: 'H264', rate: 90000),
                Rtp(payload: 97, codec: 'H264', rate: 90000)
              ],
              fmtp: [
                Fmtp(
                    payload: 97,
                    config: 'profile-level-id=4d0028;packetization-mode=1')
              ],
              type: 'video',
              port: 55400,
              protocol: 'RTP/SAVPF',
              payloads: '97 98',
              direction: 'sendrecv',
              candidates: [
                Candidate(
                    foundation: 1,
                    component: 2,
                    transport: 'UDP',
                    priority: 2113667326,
                    ip: '203.0.113.1',
                    port: 55401,
                    type: 'host'),
                Candidate(
                    foundation: 0,
                    component: 1,
                    transport: 'UDP',
                    priority: 2113667327,
                    ip: '203.0.113.1',
                    port: 55400,
                    type: 'host')
              ])
        ]);

    expect(sdp, expectedSdp);
  });

  test('Parse Origin', () {
    final expected_origin = Origin(
        username: '-',
        sessionId: 20518,
        sessionVersion: 0,
        netType: 'IN',
        ipVer: 4,
        address: '203.0.113.1');
    String str = '- 20518 0 IN IP4 203.0.113.1';
    Origin origin = parseOrigin(str);

    expect(origin, expected_origin);
  });

  test('Parse Timing', () {
    final expected_timing = Timing(start: 0, stop: 0);
    String str = '0 0';
    Timing timing = parseTiming(str);

    expect(timing, expected_timing);
  });

  test('Parse Media', () {
    final rtps = [
      Rtp(payload: 97, codec: 'H264', rate: 90000),
      Rtp(payload: 98, codec: 'VP8', rate: 90000)
    ];
    final fmtps = [
      Fmtp(payload: 97, config: 'profile-level-id=4d0028;packetization-mode=1')
    ];
    final candidates = [
      Candidate(
          foundation: 0,
          component: 1,
          transport: 'UDP',
          priority: 2113667327,
          ip: '203.0.113.1',
          port: 55400,
          type: 'host'),
      Candidate(
          foundation: 1,
          component: 2,
          transport: 'UDP',
          priority: 2113667326,
          ip: '203.0.113.1',
          port: 55401,
          type: 'host')
    ];
    final direction = 'sendrecv';
    final expected_media = Media(
      rtp: rtps,
      fmtp: fmtps,
      type: 'video',
      port: 55400,
      protocol: 'RTP/SAVPF',
      payloads: '97 98',
      direction: direction,
      candidates: candidates,
    );
    String str = 'video 55400 RTP/SAVPF 97 98';
    Media media = parseMedia(str,
        candidates: candidates, fmtps: fmtps, rtps: rtps, direction: direction);

    expect(media, expected_media);
  });

  test('ParseCandidate', () {
    final expected_candidate = Candidate(
        foundation: 1,
        component: 2,
        transport: 'UDP',
        priority: 2113667326,
        ip: '203.0.113.1',
        port: 55401,
        type: 'host');
    String str = 'candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host';
    Candidate candidate = parseCandidate(str);

    expect(candidate, expected_candidate);
  });

  test('ParseConnection', () {
    final expected_connection = Connection(version: 4, ip: '203.0.113.1');
    String str = 'IN IP4 203.0.113.1';
    Connection connection = parseConnection(str);

    expect(connection, expected_connection);
  });

  test('ParseFingerPrint', () {
    final expected_fingerprint = Fingerprint(
        type: 'sha-1',
        hash: '42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7');
    String str =
        'fingerprint:sha-1 42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7';
    Fingerprint fingerprint = parseFingerprint(str);

    expect(fingerprint, expected_fingerprint);
  });

  test('Parse fmtp', () {
    final expected_fmtps = [
      Fmtp(payload: 97, config: 'profile-level-id=4d0028;packetization-mode=1')
    ];
    String str = 'fmtp:97 profile-level-id=4d0028;packetization-mode=1';
    Fmtp fmtp = parseFmtp(str);
    final expected_fmtp = expected_fmtps[0];
    expect(fmtp, expected_fmtp);
  });

  test('Parse RTP', () {
    final expected_rtps = <Rtp>[
      Rtp(payload: 97, codec: 'H264', rate: 90000),
      Rtp(payload: 98, codec: 'VP8', rate: 90000)
    ];
    String str = 'rtpmap:97 H264/90000';
    Rtp rtp = parseRtp(str);
    final expected_rtp = expected_rtps[0];
    expect(rtp, expected_rtp);
  });
}