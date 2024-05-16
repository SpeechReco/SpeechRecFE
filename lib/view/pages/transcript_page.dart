import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';

import '../../model/analysis.dart';
import '../../model/assemblyResponse.dart';
import '../widgets/confidence_text_widget.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({Key? key, required this.analysis}) : super(key: key);

  final Analysis analysis;

  @override
  _TranscriptPageState createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  bool _showTextDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Info"),
      ),
      body: FutureBuilder<Transcript?>(
        future: DataService.getAnalysisData(widget.analysis),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Main Header",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Text Field with Confidence Text Widget and Switch
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Text transcription",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Show word confidence",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8, // Adjust the scale factor as needed
                                    child: Switch(
                                      value: _showTextDetails,
                                      onChanged: (value) {
                                        setState(() {
                                          _showTextDetails = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          ConfidenceTextWidget(
                            text: snapshot.data!.text,
                            wordConfidences: snapshot.data!.words,
                            showDetails: _showTextDetails,
                          ),
                        ],
                      ),
                    ),
                    // Generated Summary
                    _buildBlock(
                      title: "Generated Summary",
                      child: Text(
                        snapshot.data!.summary ?? "No summary available",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    // Details
                    _buildBlock(
                      title: "Details",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Audio Duration: ${snapshot.data!.audioDuration}s."),
                              Text("Expected Speakers: ${snapshot.data!.speakersExpected}"),
                              Text(
                                "Avg. Confidence: ${snapshot.data!.confidence?.toStringAsFixed(2)}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Back Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Back"),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBlock({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column
        (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}