import 'dart:convert';
import 'dart:typed_data';

import 'package:speech_rec_fe/model/assemblyResponse.dart';

import '../model/analysis.dart';
import '../model/recording.dart';
import 'package:http/http.dart' as http;

class DataService {
  static String httpBaseAudio = "http://localhost:8080/audios";
  static String httpBaseAnalysis = "http://localhost:8080/analyses";

  static Future<List<Recording>> getRecords(int userID) async {
    var response = await http.get(Uri.parse("$httpBaseAudio/$userID"));
    Iterable l = json.decode(response.body);
    return List<Recording>.from(l.map((model) => Recording.fromJson(model)));
  }

  static Future<bool> addRecord(
      int userID, String audioName, List<int> audioBytes) async {
    Recording recording =
        Recording(0, userID, audioName, "none", DateTime.now(), audioBytes);
    try {
      // Convert Recording object to JSON
      var jsonData = recording.toJson();

      // Send JSON data in the request body
      var response = await http.post(
        Uri.parse("$httpBaseAudio/$userID"),
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

  static Future<List<Analysis>> getAnalyses(int userID, int audioID) async {
    var response =
        await http.get(Uri.parse("$httpBaseAnalysis/$userID/$audioID"));
    print(response.body);
    Iterable l = json.decode(response.body);
    return List<Analysis>.from(l.map((model) => Analysis.fromJson(model)));
  }

  static Future<bool> addAnalysis(String name, int userID, int audioID, String language, int speakersAmount, bool summary) async {
    try {
      if (name.isEmpty) name = "Unnamed";

      // Send JSON data in the request body
      var response = await http.post(
        Uri.parse("$httpBaseAudio/$userID/$audioID"),
        headers: {
          "Content-Type": "application/json",
          "Analysis-Name": name,
          "Language": language,
          "Speaker-Amount": speakersAmount.toString(),
          "Enable-Summary": summary.toString(),
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // If successful, return the updated Recording object
        return true;
      } else {
        // If unsuccessful, throw an exception or handle the error accordingly
        throw Exception('Failed to create analysis');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      throw Exception('Error: $e');
    }
  }

  static Future<Uint8List> getBytes(String mPath) async {
    var response = await http.get(Uri.parse(mPath));
    return response.bodyBytes;
  }

  static Future<Transcript?> getAnalysisData(Analysis analysis) async {
    if (analysis.textURI.isEmpty) {
      return null;
    }

    var response = await http.get(Uri.parse(analysis.textURI));
    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Transcript transcript = Transcript.fromJson(jsonResponse);
      return transcript;
    } else {
      throw Exception('Failed to load analysis data');
    }
  }

  static Future<String> prompt(String analysisText, String prompt) async {
    final url = Uri.parse('http://localhost:8080/analyses/1/1/1');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'text': analysisText,
      'prompt': prompt,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {

        // Assuming the response has a field named 'response' containing the AI's response
        return response.body;
      } else {
        throw Exception('Failed to get response from the server');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  static Future<String> getText(String textURI) async {
    var response = await http.get(Uri.parse(textURI));
    return Transcript.fromJson(jsonDecode(response.body)).text;
  }

}
