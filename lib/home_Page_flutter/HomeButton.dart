import 'package:flutter/material.dart';

class CatigoryW extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback onPressed; // Add a callback for button-like behavior

  CatigoryW({
    required this.image,
    required this.text,
    required this.color,
    required this.onPressed, // Make it required for button action
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Add onTap event here to trigger the action
      child: Container(
        height: 200,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //color: Colors.orangeAccent,
          //color: const Color(0xFFFABF75),
          //color: const Color(0xFFEAB777),
            color: Color(0xFF373856),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEAB777),
              blurRadius: 15,
            ),


          ]
        ),
        child: Column(

          children: [

            const SizedBox(
              height: 20, // Adjust the height as needed
            ),
            ClipOval(
              child: Image.asset(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover, // Ensures the image fits within the circular area
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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

