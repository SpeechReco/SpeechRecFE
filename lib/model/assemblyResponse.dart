class Transcript {
  int speakersExpected;
  String text;
  String? language;
  List<TranscriptWord>? words;
  double? confidence;
  double? audioDuration;
  String? summary;

  Transcript({
    required this.speakersExpected,
    required this.text,
    required this.words,
    required this.confidence,
    required this.audioDuration,
    required this.summary,
  });

  Transcript.fromJson(Map<String, dynamic> json)
      : speakersExpected = json['speakers_expected'] ?? 1,
        text = json['text'],
        language = convertLanguage(json['language_code']),
        words = (json['words'] as List)
            .map((word) => TranscriptWord.fromJson(word))
            .toList(),
        confidence = json['confidence'] ?? 0,
        audioDuration = json['audio_duration'],
        summary = json['summary'];

  get speed => words!.length / (audioDuration!/60);

  static String convertLanguage(languageCode) {
    if (languageCode == null) return "Undefined";
    switch (languageCode) {
      case "en_us":
        return "English";
      case "uk":
        return "Ukrainian";
      default:
        return "Undefined";
    }
  }
}

class TranscriptWord {
  String text;
  double confidence;
  String speaker;

  TranscriptWord({
    required this.text,
    required this.confidence,
    required this.speaker,
  });

  TranscriptWord.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        confidence = json['confidence'],
        speaker = json['speaker'] ?? "A";
}
