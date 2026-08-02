import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  final bool connected;
  final VoidCallback onConnect;

  const ConnectionCard({
    super.key,
    required this.connected,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: connected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connected ? "Connected" : "Disconnected",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "HiveMQ Cloud",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: connected
                ? Container(
                    key: const ValueKey("online"),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "ONLINE",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : FilledButton.icon(
                    key: const ValueKey("connect"),
                    onPressed: onConnect,
                    icon: const Icon(Icons.cloud_done),
                    label: const Text("Connect"),
                  ),
          ),
        ],
      ),
    );
  }
}
