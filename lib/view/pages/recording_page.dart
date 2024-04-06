import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';

import '../../model/recording.dart';
import '../../util/mock_data_service.dart';
import '../widgets/analysis_list.dart';
import '../widgets/audioplayer.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key, required this.recording});

  final Recording recording;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recording.title)),
      body: Column(
        children: [
          const Text("Info holder"),
          AudioPlayerWidget(
            currentAudio: recording.recordingURI,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child:
                        AnalysisList(analyses: MockDataService.getMockAnalyses())),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/add-transcript",
                          arguments: recording.recordingURI);
                    },
                    child: const Text("Add new analysis"))
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Back"))
        ],
      ),
    );
  }
}
