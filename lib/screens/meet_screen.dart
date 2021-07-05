import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams/constants/keys.dart';
import 'package:teams/constants/variables.dart';

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
  bool _joinMeeting = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initializingVariables();
  }

  void initializingVariables() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.enableLocalVideo(true);
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
  }

  Future<void> joinAgoraChannel() async {
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _joinMeeting
          ? _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
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
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        top:
                            BorderSide(width: 10.0, color: Colors.indigoAccent),
                        bottom:
                            BorderSide(width: 10.0, color: Colors.indigoAccent),
                        right:
                            BorderSide(width: 10.0, color: Colors.indigoAccent),
                        left:
                            BorderSide(width: 10.0, color: Colors.indigoAccent),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: height / 2.5,
                    width: width / 1.5,
                    child: Center(
                      child: _renderLocalPreview(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RawMaterialButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        onPressed: _onToggleMute,
                        child: Icon(
                          _muted ? Icons.mic_off : Icons.mic,
                          color: Colors.indigoAccent,
                          size: 35.0,
                        ),
                      ),
                      Switch(
                        value: !_muted,
                        onChanged: (value) {
                          _onToggleMute();
                          print(_muted);
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _joinMeeting = true;
                      });
                      joinAgoraChannel().then((value) {
                        setState(() {
                          _loading = false;
                        });
                      });
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Create Meeting",
                          style: myStyle(20, Colors.white),
                        ),
                      ),
                      width: width / 1.5,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF64B5F6),
                            Color(0xFF90CAF9),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
