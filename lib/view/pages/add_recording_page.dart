import 'dart:async';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../util/data_service.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class AddRecordingPage extends StatefulWidget {
  const AddRecordingPage({super.key});

  @override
  AddRecordingState createState() => AddRecordingState();
}

class AddRecordingState extends State<AddRecordingPage> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  Uint8List buffer = Uint8List(440000);
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String? _realUrl = "";

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
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
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
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

    _mRecorderIsInited = true;
  }

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        _realUrl = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
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

  void submitRecording() async {
    try {
      var request = await http.get(Uri.parse(_realUrl!));
      var blob = request.bodyBytes;

      // Show dialog to prompt user to enter a name
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String recordingName = '';
          return AlertDialog(
            title: const Text('Enter Recording Name'),
            content: TextField(
              onChanged: (value) {
                recordingName = value;
              },
              decoration: const InputDecoration(hintText: 'Recording Name'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Call your DataService to add the record with the entered name
                  DataService.addRecord(1, recordingName, blob);
                  print('Recording submitted successfully');
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error submitting recording: $e');
    }
  }

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  _Fn? getSubmitFn() {
    if (!_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return submitRecording;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Record your speech",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: getRecorderFn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _mRecorder!.isRecording
                            ? const Color(0xFFFA4B4B)
                            : null,
                      ),
                      child: Text(
                        _mRecorder!.isRecording ? 'Stop' : 'Record',
                        style: TextStyle(
                          color: _mRecorder!.isRecording ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _mRecorder!.isRecording
                        ? 'Recording in progress'
                        : 'Recorder is stopped',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
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
                        backgroundColor: _mPlayer!.isPlaying
                            ? const Color(0xFFFA4B4B)
                            : null,
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
                    _mPlayer!.isPlaying
                        ? 'Playback in progress'
                        : 'Player is stopped',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: makeBody(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: getSubmitFn(),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      const Color(0xffffffff).withOpacity(0.3),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
