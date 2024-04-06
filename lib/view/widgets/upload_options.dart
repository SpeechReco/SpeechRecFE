import 'package:flutter/material.dart';

class UploadOptionsDialog extends StatelessWidget {
  final Color _color = const Color.fromARGB(0, 0, 0, 0);

  final String title;
  final String content;
  final String yes;
  final String no;
  final Function yesFunc;
  final Function noFunc;

  const UploadOptionsDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.yes,
      required this.no,
      required this.yesFunc,
      required this.noFunc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      backgroundColor: _color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            yesFunc();
          },
          child: Text(yes),
        ),
        ElevatedButton(
          child: Text(no),
          onPressed: () {
            noFunc();
          },
        ),
      ],
    );
  }
}
