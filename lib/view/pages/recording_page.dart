import 'package:flutter/material.dart';

import '../../model/recording.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key, required this.recording});

  final Recording recording;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(recording.title),
    );
  }
}
