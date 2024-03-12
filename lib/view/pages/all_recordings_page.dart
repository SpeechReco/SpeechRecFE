import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import 'package:speech_rec_fe/view/widgets/recording_list.dart';

class AllRecordingsPage extends StatefulWidget {
  const AllRecordingsPage({super.key});

  @override
  State<AllRecordingsPage> createState() {
    return _AllRecordingsState();
  }
}

class _AllRecordingsState extends State<AllRecordingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My recordings"),
        ),
        body: Column(
          children: [
            Expanded(
              child: RecordingList(
                recordings: DataService.getMockRecords(),
              ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: const Text("Back"))
          ],
        ));
  }
}
