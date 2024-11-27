import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onDoubleTap;
  final String text;
  const MyButtons({
    super.key,
    required this.onDoubleTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDoubleTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration:  ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Colors.blue),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}