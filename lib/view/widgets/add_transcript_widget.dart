import 'package:flutter/material.dart';

import '../../util/data_service.dart';

class AddTranscriptWidget extends StatefulWidget {
  final int recordingID;

  const AddTranscriptWidget({super.key, required this.recordingID});

  @override
  _AddTranscriptWidgetState createState() => _AddTranscriptWidgetState();
}

class _AddTranscriptWidgetState extends State<AddTranscriptWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _enableSummarization = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Generate analysis"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Analysis Name',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'Auto', child: Text('Auto-detect')),
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Ukrainian', child: Text('Ukrainian')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Language',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Speakers amount (optional)',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _enableSummarization,
                  onChanged: (value) {
                    setState(() {
                      _enableSummarization = value!;
                    });
                  },
                ),
                const Text('Create summary'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Handle submit action
                    String name = _nameController.text;
                    String language = _selectedLanguage;
                    int speakersNumber =
                        int.tryParse(_numberController.text) ?? 1;
                    bool enableSummarization = _enableSummarization;
                    bool success = await DataService.addAnalysis(
                        name,
                        1,
                        widget.recordingID,
                        language,
                        speakersNumber,
                        enableSummarization);
                    if (success) {
                      Navigator.of(context).pop();
                    } else {
                      // Handle error (e.g., show a Snackbar or Dialog)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add analysis')),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle cancel action
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
