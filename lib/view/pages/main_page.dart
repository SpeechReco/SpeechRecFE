import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import 'package:speech_rec_fe/view/widgets/upload_options.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Speech Recognition App",
              style: TextStyle(
                fontFamily: 'Roboto', // Change font if needed
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/all-recordings");
                },
                child: const Text(
                  "My Recordings",
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  _showUploadOptionsDialog(context);
                },
                child: const Text(
                  "Make a Recording",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showUploadOptionsDialog(BuildContext context) async {
    Uint8List? fileBytes;
    var baseDialog = UploadOptionsDialog(
      title: "Choose Option",
      content: "What data source would you like to choose?",
      yesFunc: () async {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.audio);

        if (result != null) {
          fileBytes = result.files.single.bytes;
          Navigator.of(context).pop(); // Close the dialog
        } else {
          Navigator.of(context).pop(); // Close the dialog
          print('No file selected');
        }
      },
      noFunc: () {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.of(context).pushNamed("/add-recording");
      },
      yes: "Storage",
      no: "Live Recording",
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) => baseDialog,
    );

    if (fileBytes == null) return;

    // Show dialog to prompt user to enter a name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String recordingName = '';
        return AlertDialog(
          title: const Text('Enter Recording Name'),
          content: TextField(
            onChanged: (value) {
              recordingName = value;
            },
            decoration: const InputDecoration(hintText: 'Recording Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call your DataService to add the record with the entered name
                DataService.addRecord(1, recordingName, fileBytes!.toList());
                print('Recording submitted successfully');
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
