import 'package:flutter/material.dart';

class CatigoryW extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback onDoubleTap; // Callback for double tap

  const CatigoryW({
    Key? key,
    required this.image,
    required this.text,
    required this.color,
    required this.onDoubleTap, // Make it required for double tap action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap, // Trigger the double tap action
      child: Container(
        height: 200,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF494C8A),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF00000B),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20), // Adjust the height as needed
            ClipOval(
              child: Image.asset(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover, // Ensures the image fits within the circular area
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}