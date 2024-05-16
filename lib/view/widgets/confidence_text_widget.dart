import 'package:flutter/material.dart';
import 'package:speech_rec_fe/model/assemblyResponse.dart';

class ConfidenceTextWidget extends StatelessWidget {
  final String text;
  final List<TranscriptWord>? wordConfidences;
  bool showDetails;

  ConfidenceTextWidget(
      {super.key,
      required this.text,
      required this.wordConfidences,
      required this.showDetails});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    // Split text into words
    text.split(' ');

    String currentSpeaker = '';

    for (var word in wordConfidences!) {
      String confidenceWord = word.text;
      double confidence = word.confidence;
      if (currentSpeaker.isEmpty) {
        currentSpeaker = word.speaker;
        spans.add(
          WidgetSpan(
            child: Text(
              "Speaker $currentSpeaker: ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else if (word.speaker != currentSpeaker) {
        currentSpeaker = word.speaker;
        spans.add(const TextSpan(text: "\n"));
        spans.add(WidgetSpan(
          child: Text(
            "Speaker $currentSpeaker: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      }

      if (!showDetails) {
        spans.add(
          WidgetSpan(
            child: Text(
              "$confidenceWord ",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      } else {
        // Determine color based on confidence value
        Color color = _getColorForConfidence(confidence);
        // Add word with colored font and background style to spans
        spans.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                _showConfidenceMenu(context, confidenceWord, confidence);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                margin: const EdgeInsets.symmetric(horizontal:2, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(111, 54, 132, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  confidenceWord,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
        // spans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Color _getColorForConfidence(double confidence) {
    // Define colors for confidence levels
    final Color highConfidenceColor = Colors.green;
    final Color mediumConfidenceColor = Colors.yellow;
    final Color lowConfidenceColor = Colors.red;

    // Define confidence thresholds
    final double highConfidenceThreshold = 0.9;
    final double mediumConfidenceThreshold = 0.4;

    // Interpolate between colors based on confidence value
    if (confidence >= highConfidenceThreshold) {
      return highConfidenceColor;
    } else if (confidence >= mediumConfidenceThreshold) {
      // Interpolate between medium and high confidence colors
      return Color.lerp(
        mediumConfidenceColor,
        highConfidenceColor,
        (confidence - mediumConfidenceThreshold) /
            (highConfidenceThreshold - mediumConfidenceThreshold),
      )!;
    } else {
      // Interpolate between low and medium confidence colors
      return Color.lerp(
        lowConfidenceColor,
        mediumConfidenceColor,
        confidence / mediumConfidenceThreshold,
      )!;
    }
  }

  void _showConfidenceMenu(
      BuildContext context, String word, double confidence) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Word: $word'),
          content: Text('Confidence: ${confidence.toStringAsFixed(2)}'),
          actions: [
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
  }
}
