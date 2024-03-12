import 'package:flutter/material.dart';

import '../../model/analysis.dart';

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({super.key, required this.analysis});

  final Analysis analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis info"),
      ),
      body: Column(
        children: [
          Text("Some data"),
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
