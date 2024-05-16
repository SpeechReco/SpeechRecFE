import 'package:flutter/material.dart';

class UploadOptionsDialog extends StatelessWidget {
  final String title;
  final String content;
  final String yes;
  final String no;
  final Function yesFunc;
  final Function noFunc;

  const UploadOptionsDialog({
    super.key,
    required this.title,
    required this.content,
    required this.yes,
    required this.no,
    required this.yesFunc,
    required this.noFunc,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF666666),
        ),
      ),
      backgroundColor: const Color(0xFFF0F0F0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            yesFunc();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6200EA), // Button color
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
          child: Text(
            yes,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            noFunc();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6200EA), // Button color
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
          child: Text(
            no,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
