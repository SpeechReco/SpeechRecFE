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
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.white.withOpacity(0.9),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            currentAnalysis.title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4D4C7D),
            ),
          ),
        ),
      ),
    );
  }
}
