import 'package:flutter/material.dart';

import '../../model/recording.dart';

class RecordingListCard extends StatelessWidget {
  const RecordingListCard({super.key, required this.currentRecording});

  final Recording currentRecording;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/recording", arguments: currentRecording);
      },
      child: Card(child: Text(currentRecording.title)),
    );
  }
}
