#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <DHTesp.h>

#include "config.h"

// ======================================================
// MQTT Topics
// ======================================================
const char* CONTROL_TOPIC = "smartlamp/control";
const char* STATUS_TOPIC  = "smartlamp/status";
const char* SENSOR_TOPIC  = "smartlamp/sensor";
const char* DEVICE_TOPIC  = "smartlamp/device";

// ======================================================
// LED PWM
// ======================================================
const int LED_PIN = 2;

const int PWM_CHANNEL = 0;
const int PWM_FREQ = 5000;
const int PWM_RESOLUTION = 8;

// ======================================================
// DHT22
// ======================================================
const int DHT_PIN = 15;
DHTesp dhtSensor;

// ======================================================

WiFiClientSecure wifiClient;
PubSubClient client(wifiClient);

unsigned long lastSensorPublish = 0;
unsigned long lastDevicePublish = 0;

// ======================================================

void setupTLS() {
  wifiClient.setInsecure();
}

// ======================================================
// MQTT CALLBACK
// ======================================================

void callback(char* topic, byte* payload, unsigned int length) {

  String message;

  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.println();
  Serial.println("=========== MQTT CONTROL ===========");
  Serial.println(message);

  JsonDocument doc;

  DeserializationError error = deserializeJson(doc, message);

  if (error) {
    Serial.print("JSON Error: ");
    Serial.println(error.c_str());
    return;
  }

  String state = doc["state"] | "OFF";
  int brightness = doc["brightness"] | 100;

  brightness = constrain(brightness, 0, 100);

  int pwm = map(brightness, 0, 100, 0, 255);

  if (state == "ON") {
    ledcWriteChannel(PWM_CHANNEL, pwm);
  } else {
    ledcWriteChannel(PWM_CHANNEL, 0);
    brightness = 0;
  }

  JsonDocument response;

  response["state"] = state;
  response["brightness"] = brightness;

  String json;

  serializeJson(response, json);

  client.publish(STATUS_TOPIC, json.c_str());

  Serial.println("Lamp Status Published");
  Serial.println(json);
}

// ======================================================
// MQTT RECONNECT
// ======================================================

void reconnect() {

  while (!client.connected()) {

    Serial.print("Connecting MQTT... ");

    String clientId = "ESP32-";
    clientId += String(random(0xffff), HEX);

    if (client.connect(
          clientId.c_str(),
          mqtt_username,
          mqtt_password)) {

      Serial.println("SUCCESS");

      client.subscribe(CONTROL_TOPIC);

      Serial.print("Subscribed -> ");
      Serial.println(CONTROL_TOPIC);

    } else {

      Serial.print("Failed rc=");
      Serial.println(client.state());

      delay(5000);
    }
  }
}

// ======================================================
// Publish Sensor
// ======================================================

void publishSensor() {

  TempAndHumidity data = dhtSensor.getTempAndHumidity();

  if (isnan(data.temperature) || isnan(data.humidity))
    return;

  JsonDocument doc;

  doc["temperature"] = data.temperature;
  doc["humidity"] = data.humidity;

  String json;

  serializeJson(doc, json);

  client.publish(SENSOR_TOPIC, json.c_str());

  Serial.println("=========== SENSOR ===========");
  Serial.println(json);
}

// ======================================================
// Publish Device Info
// ======================================================

void publishDeviceInfo() {

  JsonDocument doc;

  doc["device"] = "ESP32 Smart Lamp";
  doc["ip"] = WiFi.localIP().toString();
  doc["rssi"] = WiFi.RSSI();
  doc["uptime"] = millis() / 1000;

  String json;

  serializeJson(doc, json);

  client.publish(DEVICE_TOPIC, json.c_str());

  Serial.println("=========== DEVICE ===========");
  Serial.println(json);
}

// ======================================================
// SETUP
// ======================================================

void setup() {

  Serial.begin(115200);

  dhtSensor.setup(DHT_PIN, DHTesp::DHT22);

  ledcAttachChannel(
    LED_PIN,
    PWM_FREQ,
    PWM_RESOLUTION,
    PWM_CHANNEL
  );

  ledcWriteChannel(PWM_CHANNEL, 0);

  Serial.print("Connecting WiFi");

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {

    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("WiFi Connected");
  Serial.print("IP Address : ");
  Serial.println(WiFi.localIP());

  setupTLS();

  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

// ======================================================
// LOOP
// ======================================================

void loop() {

  if (!client.connected()) {
    reconnect();
  }

  client.loop();

  // Publish DHT22 every .5 seconds
  if (millis() - lastSensorPublish >= 500) {

    lastSensorPublish = millis();

    publishSensor();
  }

  // Publish device info every 999 ms
  if (millis() - lastDevicePublish >= 999) {

    lastDevicePublish = millis();

    publishDeviceInfo();
  }
}