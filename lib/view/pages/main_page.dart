import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import 'package:speech_rec_fe/util/mock_data_service.dart';
import 'package:speech_rec_fe/view/widgets/upload_options.dart';

import '../../model/recording.dart';

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
                _showUploadOptionsDialog(context);
              },
              child: const Text("Make a recording")),
        ],
      ),
    );
  }

  void _showUploadOptionsDialog(BuildContext context) {
    var baseDialog = UploadOptionsDialog(
      title: "Choose option",
      content: "What data source would you like to choose?",
      yesFunc: () {
        FilePickerResult? result = FilePicker.platform.pickFiles() as FilePickerResult?;

        if (result != null) {
          String? filePath = result.files.single.path;
          Recording newRecording = MockDataService.addMockRecord(filePath!);
          Navigator.of(context).pop(); // Close the dialog
          Navigator.of(context)
              .pushNamed("/recording", arguments: newRecording);
          print('Selected file: $filePath');
        } else {
          Navigator.of(context).pop(); // Close the dialog
          print('No file selected');
        }
      },
      noFunc: () {
        Navigator.of(context).pushNamed("/add-recording");
      },
      yes: "Storage",
      no: "Live recording",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => baseDialog,
    );
  }
}
