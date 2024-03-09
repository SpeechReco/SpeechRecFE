import 'package:flutter/material.dart';
import 'package:speech_rec_fe/view/widgets/recording_list_card.dart';

import '../../model/recording.dart';

class RecordingList extends StatelessWidget {
  const RecordingList({super.key, required this.recordings});

  final List<Recording> recordings;

  @override
  Widget build(BuildContext context) {
    if (recordings.isEmpty) {
      return const Scaffold(
        body: Text("No recordings"),
      );
    }
    return ListView.builder(
        itemCount: recordings.length,
        itemBuilder: (_, index) =>
            RecordingListCard(currentRecording: recordings[index]));
  }
}
