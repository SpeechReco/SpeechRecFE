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
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:  Color(0xFF4D4C7D),
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF4D4C7D),
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
          child: Text(
            yes,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            noFunc();
          },
          child: Text(
            no,
          ),
        ),
      ],
    );
  }
}
