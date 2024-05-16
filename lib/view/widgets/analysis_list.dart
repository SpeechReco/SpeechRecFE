import 'package:flutter/material.dart';
import 'package:speech_rec_fe/model/analysis.dart';

import 'analysis_list_card.dart';

class AnalysisList extends StatelessWidget {
  const AnalysisList({Key? key, required this.analyses}) : super(key: key);

  final Future<List<Analysis>> analyses;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Analysis>>(
      future: analyses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                "No analyses available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: AnalysisListCard(
                        currentAnalysis: snapshot.data![index]),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
