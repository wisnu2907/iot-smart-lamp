import 'package:flutter/material.dart';

class LampIcon extends StatelessWidget {
  final bool isOn;

  const LampIcon({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn
            ? Colors.red.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.08),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.75),
                  blurRadius: 70,
                  spreadRadius: 20,
                ),
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.35),
                  blurRadius: 120,
                  spreadRadius: 35,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Icon(
            Icons.lightbulb_rounded,
            key: ValueKey(isOn),
            size: 110,
            color: isOn ? Colors.red : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
