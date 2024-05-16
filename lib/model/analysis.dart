import 'package:intl/intl.dart';

class Analysis {
  int id;
  int recordingID;
  String title;
  String textURI;
  String? config;
  DateTime creationDate;


  Analysis(this.id, this.title, this.recordingID, this.textURI,
      this.creationDate, this.config);

  Analysis.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        recordingID = json['recordingID'],
        textURI = json['textURI'],
        title = json['title'],
        creationDate = DateTime.parse(json['creationDate']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'recordingID': recordingID,
    'textURI': textURI,
    'title': title,
    'config': config,
    'creationDate': DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(creationDate),
  };
}
