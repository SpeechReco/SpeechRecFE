import 'package:flutter/material.dart';
import 'package:speech_rec_fe/model/analysis.dart';

import 'analysis_list_card.dart';

class AnalysisList extends StatelessWidget {
  const AnalysisList({super.key, required this.analyses});

  final List<Analysis> analyses;

  @override
  Widget build(BuildContext context) {
    if (analyses.isEmpty) {
      return const Scaffold(
        body: Text("No analyses"),
      );
    }
    return ListView.builder(
        itemCount: analyses.length,
        itemBuilder: (_, index) =>
            AnalysisListCard(currentAnalysis: analyses[index]));
  }
}
