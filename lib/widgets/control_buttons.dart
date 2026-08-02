import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool lampOn;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;

  const ControlButtons({
    super.key,
    required this.lampOn,
    required this.onTurnOn,
    required this.onTurnOff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: lampOn ? null : onTurnOn,
            icon: const Icon(Icons.flash_on),
            label: const Text("Turn ON"),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: lampOn ? onTurnOff : null,
            icon: const Icon(Icons.power_settings_new),
            label: const Text("Turn OFF"),
          ),
        ),
      ],
    );
  }
}
