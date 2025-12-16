import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onpressed;
  final String txt_title;
  final double? height;
  const MyButton(
      {super.key,
      required this.onpressed,
      required this.txt_title,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 70),
      ),
      child: Text(
        txt_title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
