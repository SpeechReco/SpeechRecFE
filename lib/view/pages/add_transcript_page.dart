import 'package:flutter/material.dart';

class AddTranscriptPage extends StatelessWidget {
  const AddTranscriptPage({super.key, required this.recordingURI});

  final String recordingURI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate analysis")),
      body: Container(
        child: Column(
          children: [
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Back"))
          ],
        ),
      ),
    );
  }
}
