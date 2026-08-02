# 💡 IoT Smart Lamp with ESP32, Flutter & HiveMQ Cloud

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![ESP32](https://img.shields.io/badge/ESP32-IoT-E7352C)
![MQTT](https://img.shields.io/badge/MQTT-HiveMQ-660066?logo=eclipsemosquitto)
![HiveMQ Cloud](https://img.shields.io/badge/HiveMQ-Cloud-yellow)
![Arduino](https://img.shields.io/badge/Arduino-C++-00979D?logo=arduino)
![Wokwi](https://img.shields.io/badge/Wokwi-Simulation-blue)
![License](https://img.shields.io/badge/License-MIT-green)

A modern IoT Smart Lamp system built using **ESP32**, **Flutter**, **MQTT**, and **HiveMQ Cloud**.

A modern IoT Smart Lamp system built using **ESP32**, **Flutter**, **MQTT**, and **HiveMQ Cloud**. The application allows real-time remote control of an LED lamp while monitoring environmental conditions using a DHT22 sensor.

---

## 📸 Project Preview

> **Coming Soon**

- Flutter Application Screenshot
- ESP32 Hardware
- Wokwi Simulation
- System Architecture

---

## ✨ Features

- 💡 Remote ON/OFF lamp control
- 🌞 Adjustable LED brightness (PWM)
- 🌡 Real-time temperature monitoring
- 💧 Real-time humidity monitoring
- 📡 MQTT communication using HiveMQ Cloud
- 📶 Device monitoring
  - IP Address
  - WiFi Signal Strength (RSSI)
  - Device Uptime
- 🔄 Automatic MQTT reconnect
- 🔒 Secure MQTT over TLS (Port 8883)
- 📱 Flutter Material 3 User Interface
- 🧪 Wokwi simulation included

---

## 🛠 Tech Stack

### Mobile App

- Flutter
- Dart
- MQTT Client

### Firmware

- ESP32
- Arduino Framework
- PubSubClient
- ArduinoJson
- DHTesp

### Cloud

- HiveMQ Cloud
- MQTT over TLS

### Simulation

- Wokwi

---

## 📂 Project Structure

```text
iot-smart-lamp/

├── android/
├── lib/
├── web/
├── windows/

├── esp32/
│   ├── smart_lamp.ino
│   ├── config.example.h
│   ├── diagram.json
│   ├── libraries.txt
│   └── wokwi.toml

├── images/

├── pubspec.yaml
└── README.md
```

---

## 🚀 Main Capabilities

### Flutter Application

- MQTT connection management
- Lamp control
- Brightness slider
- Real-time sensor monitoring
- Device information display

### ESP32 Firmware

- MQTT Subscriber
- MQTT Publisher
- PWM LED Control
- DHT22 Sensor Reading
- Device Information Publisher
- Automatic Reconnection

---

## 📡 MQTT Topics

| Topic | Description |
|--------|-------------|
| `smartlamp/control` | Receive lamp control commands |
| `smartlamp/status` | Publish lamp status |
| `smartlamp/sensor` | Publish temperature & humidity |
| `smartlamp/device` | Publish device information |

---

## 🔧 Hardware

- ESP32 DevKit V4
- DHT22 Temperature & Humidity Sensor
- LED
- 220Ω Resistor

---

## 📄 License

This project is released under the MIT License.
