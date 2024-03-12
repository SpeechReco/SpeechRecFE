import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main page"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/all-recordings");
              },
              child: const Text("My recordings")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/add-recording");
              }, child: const Text("Make a recording")),
        ],
      ),
    );
  }
}
