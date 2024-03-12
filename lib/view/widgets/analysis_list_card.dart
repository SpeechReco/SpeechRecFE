import 'package:flutter/material.dart';
import 'package:speech_rec_fe/model/analysis.dart';

class AnalysisListCard extends StatelessWidget {
  const AnalysisListCard({super.key, required this.currentAnalysis});

  final Analysis currentAnalysis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/transcript", arguments: currentAnalysis);
      },
      child: Card(child: Text(currentAnalysis.title)),
    );
  }
}
