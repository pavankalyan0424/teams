import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams/constants/keys.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {

  int _remoteUid = 0;
  bool _userJoined = false;
  late RtcEngine _engine;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    initializingVariables();
  }

  void initializingVariables() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          print("local user $uid joined");
        },
        userJoined: (uid, elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
            _userJoined = true;
          });
        },
        userOffline: (uid, reason) {
          print("remote user $uid left the channel");
          setState(() {
            _remoteUid = 0;
            _userJoined = false;
          });
        },
      ),
    );
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, "123456", null, 0);
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
    _engine.destroy();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: _muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: _renderLocalPreview(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _toolbar(),
          ),
        ],
      ),
    );
  }

  // current user video
  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  // remote user video
  Widget _renderRemoteVideo() {
    if (_userJoined) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
