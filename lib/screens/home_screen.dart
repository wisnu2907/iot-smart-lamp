import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../services/mqtt_service.dart';
import '../widgets/control_buttons.dart';
import '../widgets/lamp_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MQTTService mqttService = MQTTService();

  bool mqttConnected = false;

  bool lampOn = false;
  double brightness = 100;

  double temperature = 0;
  double humidity = 0;

  String deviceName = "-";
  String ipAddress = "-";
  int rssi = 0;
  int uptime = 0;

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return false;

      setState(() {
        mqttConnected =
            mqttService.client?.connectionStatus?.state ==
            MqttConnectionState.connected;
      });

      return true;
    });
  }

  Future<void> connectMQTT() async {
    final connected = await mqttService.connect(
      server: dotenv.env["MQTT_SERVER"]!,
      username: dotenv.env["MQTT_USERNAME"]!,
      password: dotenv.env["MQTT_PASSWORD"]!,
    );

    setState(() {
      mqttConnected = connected;
    });

    if (!connected) return;

    mqttService.subscribe([
      "smartlamp/status",
      "smartlamp/sensor",
      "smartlamp/device",
    ]);

    mqttService.onStatusChanged = (state, bright) {
      setState(() {
        lampOn = state == "ON";
        brightness = bright.toDouble();
      });
    };

    mqttService.onSensorChanged = (temp, hum) {
      setState(() {
        temperature = temp;
        humidity = hum;
      });
    };

    mqttService.onDeviceChanged = (device, ip, wifi, up) {
      setState(() {
        deviceName = device;
        ipAddress = ip;
        rssi = wifi;
        uptime = up;
      });
    };
  }

  void publishLamp() {
    mqttService.publish(
      "smartlamp/control",
      jsonEncode({
        "state": lampOn ? "ON" : "OFF",
        "brightness": brightness.toInt(),
      }),
    );
  }

  void turnOn() {
    lampOn = true;
    publishLamp();
  }

  void turnOff() {
    lampOn = false;
    publishLamp();
  }

  Widget buildConnectionCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.cloud_done,
          color: mqttConnected ? Colors.green : Colors.red,
        ),
        title: Text(mqttConnected ? "Connected" : "Disconnected"),
        subtitle: const Text("HiveMQ Cloud"),
        trailing: mqttConnected
            ? null
            : FilledButton(
                onPressed: connectMQTT,
                child: const Text("Connect"),
              ),
      ),
    );
  }

  Widget buildSensorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.thermostat, size: 36),
                  const SizedBox(height: 10),
                  const Text("Temperature"),
                  Text(
                    "${temperature.toStringAsFixed(1)} °C",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.water_drop, size: 36),
                  const SizedBox(height: 10),
                  const Text("Humidity"),
                  Text(
                    "${humidity.toStringAsFixed(1)} %",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.memory),
                SizedBox(width: 8),
                Text(
                  "Device Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const Divider(height: 30),
            ListTile(
              dense: true,
              leading: const Icon(Icons.devices),
              title: const Text("Device"),
              trailing: Text(deviceName),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.router),
              title: const Text("IP Address"),
              trailing: Text(ipAddress),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.wifi),
              title: const Text("RSSI"),
              trailing: Text("$rssi dBm"),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.timer),
              title: const Text("Uptime"),
              trailing: Text("$uptime s"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBrightnessCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.brightness_6),
                SizedBox(width: 8),
                Text(
                  "Brightness",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: brightness,
              min: 0,
              max: 100,
              divisions: 100,
              label: "${brightness.toInt()}%",
              onChanged: (value) {
                setState(() {
                  brightness = value;
                });

                publishLamp();
              },
            ),
            Text(
              "${brightness.toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      appBar: AppBar(centerTitle: true, title: const Text("Smart Lamp")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildConnectionCard(),
            const SizedBox(height: 20),

            LampCard(lampOn: lampOn),
            const SizedBox(height: 20),

            buildSensorCard(),
            const SizedBox(height: 20),

            buildDeviceCard(),
            const SizedBox(height: 20),

            buildBrightnessCard(),
            const SizedBox(height: 20),

            ControlButtons(
              lampOn: lampOn,
              onTurnOn: turnOn,
              onTurnOff: turnOff,
            ),
          ],
        ),
      ),
    );
  }
}
