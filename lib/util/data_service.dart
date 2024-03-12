import '../model/analysis.dart';
import '../model/recording.dart';

class DataService {
  static List<Recording> getMockRecords() {
    return [
      Recording(1, 1001, 'Sample Recording 1',
          'https://example.com/recording1.mp3', DateTime.now()),
      Recording(2, 1002, 'Sample Recording 2',
          'https://example.com/recording2.mp3', DateTime.now()),
      Recording(3, 1003, 'Sample Recording 3',
          'https://example.com/recording3.mp3', DateTime.now()),
    ];
  }

  static List<Analysis> getMockAnalyses() {
    return [
      Analysis(
        1,
        101,
        'Analysis 1',
        201,
        301,
        DateTime.now(),
        'Config 1',
      ),
      Analysis(
        2,
        102,
        'Analysis 2',
        202,
        302,
        DateTime.now(),
        'Config 2',
      ),
      Analysis(
        3,
        103,
        'Analysis 3',
        203,
        303,
        DateTime.now(),
        'Config 3',
      ),
    ];
  }
}
