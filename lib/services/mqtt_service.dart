import 'dart:convert';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient? client;

  // =============================
  // Callbacks
  // =============================

  Function(String state, int brightness)? onStatusChanged;

  Function(double temperature, double humidity)? onSensorChanged;

  Function(String device, String ip, int rssi, int uptime)? onDeviceChanged;

  // =============================
  // CONNECT
  // =============================

  Future<bool> connect({
    required String server,
    required String username,
    required String password,
  }) async {
    client = MqttServerClient.withPort(server, "flutter_client", 8883);

    client!.secure = true;
    client!.securityContext = SecurityContext.defaultContext;

    client!.keepAlivePeriod = 20;
    client!.autoReconnect = true;

    client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier("flutter_client")
        .startClean();

    client!.onConnected = () {
      print("MQTT Connected");
    };

    client!.onDisconnected = () {
      print("MQTT Disconnected");
    };

    client!.onSubscribed = (topic) {
      print("Subscribed -> $topic");
    };

    try {
      await client!.connect(username, password);

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        return true;
      }

      client!.disconnect();
      return false;
    } catch (e) {
      print(e);

      client!.disconnect();

      return false;
    }
  }

  // =============================
  // SUBSCRIBE
  // =============================

  void subscribe(List<String> topics) {
    if (client == null) return;

    for (final topic in topics) {
      client!.subscribe(topic, MqttQos.atLeastOnce);
    }

    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      final recMess = events.first.payload as MqttPublishMessage;

      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      final topic = events.first.topic;

      try {
        final json = jsonDecode(payload);

        switch (topic) {
          case "smartlamp/status":
            onStatusChanged?.call(json["state"], json["brightness"]);
            break;

          case "smartlamp/sensor":
            onSensorChanged?.call(
              (json["temperature"] as num).toDouble(),
              (json["humidity"] as num).toDouble(),
            );
            break;

          case "smartlamp/device":
            onDeviceChanged?.call(
              json["device"],
              json["ip"],
              json["rssi"],
              json["uptime"],
            );
            break;
        }
      } catch (e) {
        print(e);
      }
    });
  }

  // =============================
  // PUBLISH
  // =============================

  void publish(String topic, String payload) {
    if (client == null) return;

    if (client!.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }

    final builder = MqttClientPayloadBuilder();

    builder.addString(payload);

    client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // =============================
  // DISCONNECT
  // =============================

  void disconnect() {
    client?.disconnect();
  }
}
