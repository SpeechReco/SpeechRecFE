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
}
