import 'dart:convert';
import 'dart:typed_data';

import '../model/analysis.dart';
import '../model/recording.dart';
import 'package:http/http.dart' as http;

class DataService {
  static String httpBase = "http://localhost:8080/audios/1";
  static Uri url = Uri.parse(httpBase);

  static Future<List<Recording>> getRecords() async {
    var response = await http.get(url);
    Iterable l = json.decode(response.body);
    return List<Recording>.from(l.map((model)=> Recording.fromJson(model)));
  }

  static Future<bool> addRecord(List<int> audioBytes) async {
    print(audioBytes);
    Recording recording =
    Recording(4, 1, 'Sample Recording 4', "none", DateTime.now(), audioBytes);
    try {
      // Convert Recording object to JSON
      var jsonData = recording.toJson();

      // Send JSON data in the request body
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // If successful, return the updated Recording object
        return true;
      } else {
        // If unsuccessful, throw an exception or handle the error accordingly
        throw Exception('Failed to add recording');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      throw Exception('Error: $e');
    }
  }

  static Future<Uint8List> getBytes(String mPath) async {
    var response = await http.get(Uri.parse(mPath));
    print(response.body);
    print(response.bodyBytes);
    return response.bodyBytes;
  }


}
