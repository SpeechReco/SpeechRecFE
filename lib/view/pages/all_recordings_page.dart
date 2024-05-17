import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import 'package:speech_rec_fe/view/widgets/recording_list.dart';
import '../../model/recording.dart';

class AllRecordingsPage extends StatefulWidget {
  const AllRecordingsPage({super.key});

  @override
  State<AllRecordingsPage> createState() => _AllRecordingsState();
}

class _AllRecordingsState extends State<AllRecordingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              "Your recordings",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Recording>>(
                future: DataService.getRecords(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recordings found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  } else {
                    return RecordingList(
                      recordings: snapshot.data!,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Back"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
