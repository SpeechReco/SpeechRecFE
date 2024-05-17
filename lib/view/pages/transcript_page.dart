import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';

import '../../model/analysis.dart';
import '../../model/assemblyResponse.dart';
import '../widgets/confidence_text_widget.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({Key? key, required this.analysis}) : super(key: key);

  final Analysis analysis;

  @override
  _TranscriptPageState createState() =>
      _TranscriptPageState(analysis: analysis);
}

class _TranscriptPageState extends State<TranscriptPage> {
  bool _showTextDetails = false;
  bool _showTranscription = true;

  _TranscriptPageState({required this.analysis});

  final Analysis analysis;

  // Determine the color based on the average speed
  Color getColorForSpeed(double? speed) {
    if (speed != null) {
      if (speed < 100) {
        return Colors.red; // Slow speech
      } else if (speed >= 100 && speed <= 180) {
        return Colors.green; // Fine speech
      } else {
        return Colors.blue; // Fast speech
      }
    } else {
      return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: 25),
                    Text(
                      analysis.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Text Field with Confidence Text Widget and Switch
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showTranscription = !_showTranscription;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Text transcription",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4D4C7D),
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
                                      scale: 0.8,
                                      // Adjust the scale factor as needed
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
                          ),
                          if (_showTranscription) ...[
                            const SizedBox(height: 8),
                            ConfidenceTextWidget(
                              text: snapshot.data!.text,
                              wordConfidences: snapshot.data!.words,
                              showDetails: _showTextDetails,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Generated Summary
                    _buildBlock(
                      title: "Generated Summary",
                      child: Text(
                        snapshot.data!.summary ?? "No summary available",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D4C7D),
                        ),
                      ),
                    ),
                    // Details
                    _buildBlock(
                      title: "Details",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Audio Duration: ${snapshot.data!.audioDuration}s.",
                            style: const TextStyle(
                                color: Color(0xFF4D4C7D), fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Language: ${snapshot.data!.language}",
                            style: const TextStyle(
                                color: Color(0xFF4D4C7D), fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Avg. speed: ',
                                  style: TextStyle(
                                      color: Color(0xFF4D4C7D), fontSize: 16),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Speech Speed Information',
                                              style: TextStyle(
                                                color: Color(0xFF4D4C7D),
                                              ),
                                            ),
                                            content: Text(
                                              'The average speech speed is ${snapshot.data!.speed?.toStringAsFixed(2) ?? "Undefined"} words per minute.',
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(4,1,4,1),
                                      decoration: BoxDecoration(
                                        color: getColorForSpeed(
                                            snapshot.data!.speed),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        snapshot.data!.speed
                                                ?.toStringAsFixed(2) ??
                                            "Undefined",
                                        style: const TextStyle(
                                          fontSize:
                                              14, // Adjust font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(
                                  text: ' words per min.',
                                  style: TextStyle(
                                      color: Color(0xFF4D4C7D), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Avg. Confidence: ${snapshot.data!.confidence?.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Color(0xFF4D4C7D),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Back"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/gpt-generator",
                                  arguments: analysis);
                            },
                            child: const Text("Ask GPT"),
                          ),
                        ],
                      ),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D4C7D)),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
