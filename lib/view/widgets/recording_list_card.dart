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
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.white.withOpacity(0.9),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            currentRecording.title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4D4C7D),
            ),
          ),
        ),
      ),
    );
  }
}
