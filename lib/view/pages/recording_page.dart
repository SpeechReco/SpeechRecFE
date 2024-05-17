import 'package:flutter/material.dart';

import '../../model/recording.dart';
import '../../util/data_service.dart';
import '../widgets/add_transcript_widget.dart';
import '../widgets/analysis_list.dart';
import '../widgets/audioplayer.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key, required this.recording});

  final Recording recording;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Text(
              recording.title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 15),
            AudioPlayerWidget(
              currentAudio: recording.recordingURI,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AnalysisList(
                      analyses: DataService.getAnalyses(1, recording.id),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddTranscriptWidget(recordingID: recording.id);
                      },
                    );
                  },
                  child: const Text("Add New Analysis"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
