import 'package:flutter/material.dart';
import 'lamp_icon.dart';

class LampCard extends StatelessWidget {
  final bool lampOn;

  const LampCard({super.key, required this.lampOn});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            LampIcon(isOn: lampOn),

            const SizedBox(height: 25),

            Text(
              "Living Room Lamp",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 25),

            Text(
              lampOn ? "ON" : "OFF",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: lampOn ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
