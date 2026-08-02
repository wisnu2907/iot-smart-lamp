import 'package:flutter/material.dart';

class BrightnessCard extends StatelessWidget {
  final double brightness;
  final ValueChanged<double> onChanged;

  const BrightnessCard({
    super.key,
    required this.brightness,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.brightness_6),
                SizedBox(width: 10),
                Text(
                  "Brightness",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Slider(
              value: brightness,
              min: 0,
              max: 100,
              divisions: 100,
              label: "${brightness.toInt()}%",
              onChanged: onChanged,
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "${brightness.toInt()}%",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
