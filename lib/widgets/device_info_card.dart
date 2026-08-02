import 'package:flutter/material.dart';

class DeviceInfoCard extends StatelessWidget {
  final String deviceName;
  final String ipAddress;
  final String wifi;
  final int uptime;

  const DeviceInfoCard({
    super.key,
    required this.deviceName,
    required this.ipAddress,
    required this.wifi,
    required this.uptime,
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
                Icon(Icons.memory),
                SizedBox(width: 10),
                Text(
                  "Device Information",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            buildRow(Icons.devices, "Device", deviceName),
            buildRow(Icons.language, "IP Address", ipAddress),
            buildRow(Icons.wifi, "WiFi RSSI", wifi),
            buildRow(Icons.timer_outlined, "Uptime", "$uptime sec"),
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
