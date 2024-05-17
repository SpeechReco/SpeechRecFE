import 'package:flutter/material.dart';
import 'package:speech_rec_fe/util/data_service.dart';
import '../../model/analysis.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({Key? key, required this.analysis}) : super(key: key);

  final Analysis analysis;

  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final TextEditingController _promptController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendPrompt() async {
    final String prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add({'role': 'user', 'content': prompt});
      _promptController.clear();
    });

    try {
      final String response = await DataService.prompt(
          await DataService.getText(widget.analysis.textURI), prompt);
      setState(() {
        _messages.add({'role': 'ai', 'content': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'error', 'content': 'Error occurred: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Chat with AI Model",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message['role'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: message['role'] == 'user'
                              ? Colors.blue[200]
                              : message['role'] == 'error'
                                  ? Colors.red[200]
                                  : Colors.green[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['content']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(color: Colors.white,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      controller: _promptController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5)
                        ),
                        helperStyle: const TextStyle(
                            color: Colors.white
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            )),
                        labelText: 'Enter your prompt',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (value) => _sendPrompt(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _isLoading ? null : _sendPrompt,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Back"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
