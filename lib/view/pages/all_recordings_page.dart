import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import 'package:speech_rec_fe/view/widgets/recording_list.dart';

import '../../model/recording.dart';

class AllRecordingsPage extends StatefulWidget {
  const AllRecordingsPage({super.key});

  @override
  State<AllRecordingsPage> createState() {
    return _AllRecordingsState();
  }
}

class _AllRecordingsState extends State<AllRecordingsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My recordings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Recording>>(
              future: DataService.getRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the future to complete, show a loading indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // If an error occurred while fetching data, show an error message
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // If the data is successfully fetched, display it using RecordingList
                  return RecordingList(
                    recordings: snapshot.data ?? [],
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }
}