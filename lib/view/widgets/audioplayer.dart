import 'dart:async';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_rec_fe/util/data_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key, required this.currentAudio});

  final String currentAudio;

  @override
  State<AudioPlayerWidget> createState() =>
      _AudioPlayerWidgetState(currentAudio);
}

typedef _Fn = void Function();

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  Codec _codec = Codec.aacMP4;
  final String _mPath;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;

  late Uint8List _buffer;

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  _AudioPlayerWidgetState(this._mPath);

  Future<void> play() async {
    assert(_mPlayerIsInited && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromDataBuffer: await DataService.getBytes(_mPath),
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _Fn? getPlaybackFn() {
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 40,
            child: ElevatedButton(
              onPressed: getPlaybackFn(),
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.white.withOpacity(0.3),
                backgroundColor:
                    _mPlayer!.isPlaying ? const Color(0xFFFA4B4B) : null,
              ),
              child: Text(
                _mPlayer!.isPlaying ? 'Stop' : 'Play',
                style: TextStyle(
                  color: _mPlayer!.isPlaying ? Colors.white : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _mPlayer!.isPlaying ? 'Playback in progress' : 'Player is stopped',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
