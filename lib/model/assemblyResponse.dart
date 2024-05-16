
class Transcript {
  int speakersExpected;
  String text;
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
        words = (json['words'] as List)
            .map((word) => TranscriptWord.fromJson(word))
            .toList(),
        confidence = json['confidence'] ?? 0,
        audioDuration = json['audio_duration'],
        summary = json['summary'];


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