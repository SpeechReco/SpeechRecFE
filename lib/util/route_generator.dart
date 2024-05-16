import 'package:flutter/material.dart';
import 'package:speech_rec_fe/model/analysis.dart';
import 'package:speech_rec_fe/view/pages/add_recording_page.dart';
import 'package:speech_rec_fe/view/widgets/add_transcript_widget.dart';
import 'package:speech_rec_fe/view/pages/all_recordings_page.dart';
import 'package:speech_rec_fe/view/pages/main_page.dart';
import 'package:speech_rec_fe/view/pages/recording_page.dart';

import '../model/recording.dart';
import '../view/pages/transcript_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/add-recording':
        return MaterialPageRoute(builder: (_) => const AddRecordingPage());
      case '/all-recordings':
        return MaterialPageRoute(builder: (_) => const AllRecordingsPage());
      case '/recording':
        if (args is Recording) {
          return MaterialPageRoute(
              builder: (_) => RecordingPage(recording: args));
        }
      case '/transcript':
        if (args is Analysis) {
          return MaterialPageRoute(
              builder: (_) => TranscriptPage(analysis: args));
        }
      case '/login':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const MainPage());
      default:
        return _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return const Scaffold(
          body: Text("Error"),
        );
      },
    );
  }
}
