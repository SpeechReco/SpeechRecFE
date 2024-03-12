import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecordingPage extends StatelessWidget {
  const AddRecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add recording"),
      ),
      body: Column(
        children: [
          const Text("Uploaded recording placeholder"),
          Container(
            child: const Row(
              children: [Text("Memory"), Text("Realtime")],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Back")),
        ],
      ),
    );
  }
}
