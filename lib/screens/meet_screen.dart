import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams/constants/keys.dart';
import 'package:teams/constants/variables.dart';

class MeetScreen extends StatefulWidget {
  final String roomCode;

  const MeetScreen({Key? key, required this.roomCode}) : super(key: key);

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  int _remoteUid = 0;
  bool _userJoined = false;
  late RtcEngine _engine;
  bool _muted = false;
  bool _loading = true;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initializingVariables();
  }

  void initializingVariables() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    // await _engine.enableLocalVideo(true);
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
    try {
      await _engine.joinChannel(null, widget.roomCode, null, 0);
    } catch (e) {
      print("Error");
    }
    setState(() {
      _loading = false;
    });
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
      padding: const EdgeInsets.only(top: 15, bottom: 48),
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
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        title: Text(
          "RoomId: ${widget.roomCode}",
          style: myStyle(20, Colors.white, FontWeight.w800),
        ),
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                    border: const Border(
                      top: BorderSide(width: 4, color: Colors.indigoAccent),
                      bottom: BorderSide(width: 4, color: Colors.indigoAccent),
                      right: BorderSide(width: 4, color: Colors.indigoAccent),
                      left: BorderSide(width: 4, color: Colors.indigoAccent),
                    ),
                  ),
                  child: Center(
                      child:
                          _switch ? _renderLocalVideo() : _renderRemoteVideo()),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_userJoined) {
                            setState(() {
                              _switch = !_switch;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: const Border(
                              top: BorderSide(
                                  width: 4, color: Colors.indigoAccent),
                              bottom: BorderSide(
                                  width: 4, color: Colors.indigoAccent),
                              right: BorderSide(
                                  width: 4, color: Colors.indigoAccent),
                              left: BorderSide(
                                  width: 4, color: Colors.indigoAccent),
                            ),
                          ),
                          width: width / 3,
                          height: height / 5,
                          child: _switch
                              ? _renderRemoteVideo()
                              : _renderLocalVideo(),
                        ),
                      ),
                      _toolbar(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // current user video
  Widget _renderLocalVideo() {
    return RtcLocalView.SurfaceView();
  }

  // remote user video
  Widget _renderRemoteVideo() {
    if (_userJoined) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Text(
        'Please wait for other user to join',
        style: myStyle(20, Colors.white, FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }
  }
}
