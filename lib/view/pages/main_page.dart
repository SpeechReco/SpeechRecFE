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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF0F0F0), // Slight background color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the Speech Recognition App",
                style: TextStyle(
                  fontFamily: 'Roboto', // Change font if needed
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/all-recordings");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EA), // Button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  "My Recordings",
                  style: TextStyle(
                    fontFamily: 'Roboto', // Change font if needed
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showUploadOptionsDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6200EA), // Button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  "Make a Recording",
                  style: TextStyle(
                    fontFamily: 'Roboto', // Change font if needed
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
