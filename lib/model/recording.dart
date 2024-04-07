import 'dart:convert';
import 'package:intl/intl.dart';

class Recording {
  int id;
  int userID;
  String title;
  String recordingURI;
  DateTime creationDate;

  List<int>? audioBytes;

  Recording(
      this.id, this.userID, this.title, this.recordingURI, this.creationDate, this.audioBytes);

  Recording.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userID = json['userID'],
        title = json['title'],
        recordingURI = json['recordingURI'],
        creationDate = DateTime.parse(json['creationDate']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userID': userID,
    'title': title,
    'recordingURI': recordingURI,
    'creationDate': DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(creationDate),
    'audioBytes': audioBytes!,
  };
}
