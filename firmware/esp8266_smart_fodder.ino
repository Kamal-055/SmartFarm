/*
 * ======================================================================================
 * SMART FODDER - ESP8266 NodeMCU Firmware
 * IoT-Based Smart Gravity Fodder Dispensing System for Cattle
 * ======================================================================================
 * 
 * Hardware Setup:
 *   - Microcontroller: ESP8266 NodeMCU (ESP-12E)
 *   - Servo Motor: MG996R or SG90 connected to Pin D4 (GPIO2)
 *   - Power Supply: 5V 2A DC adapter (Common ground with NodeMCU)
 *   - Optional Feed Sensor: Ultrasonic HC-SR04 (Trig D6, Echo D7)
 * 
 * Firebase Architecture Path:
 *   - Devices: devices/DEVICE_001/
 *   - Listen Path: devices/DEVICE_001/gate/command
 *   - Status Path: devices/DEVICE_001/gate/status
 *   - Heartbeat Path: devices/DEVICE_001/system/
 * 
 * Servo Angle Mapping:
 *   - CLOSED = 0 degrees
 *   - OPEN = 90 degrees
 * ======================================================================================
 */

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <Servo.h>

// --------------------------------------------------------------------------------------
// CONFIGURATION PARAMETERS (Fill in your Wi-Fi & Firebase credentials)
// --------------------------------------------------------------------------------------
#define WIFI_SSID       "YOUR_WIFI_SSID"
#define WIFI_PASSWORD   "YOUR_WIFI_PASSWORD"

#define FIREBASE_HOST   "your-project-id-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH   "YOUR_FIREBASE_DATABASE_SECRET_OR_WEB_API_KEY"

#define DEVICE_ID       "DEVICE_001"

// Hardware Pins
#define SERVO_PIN       D4   // Servo control signal pin
#define CLOSED_ANGLE    0    // 0 degrees = Gate Closed
#define OPEN_ANGLE      90   // 90 degrees = Gate Open

// Objects
Servo gateServo;
FirebaseData firebaseData;
FirebaseAuth auth;
FirebaseConfig config;

// State Tracking
String currentGateStatus = "CLOSED";
String lastProcessedCommandId = "";
unsigned long lastHeartbeatTime = 0;
const unsigned long HEARTBEAT_INTERVAL = 10000; // 10 seconds

// Function Prototypes
void connectWiFi();
void initFirebase();
void updateHeartbeat();
void checkGateCommands();
void moveServoSlowly(int startAngle, int targetAngle, int stepDelayMs);

void setup() {
  Serial.begin(115200);
  Serial.println("\n[SMART FODDER] Booting ESP8266 NodeMCU...");

  // Attach Servo
  gateServo.attach(SERVO_PIN);
  gateServo.write(CLOSED_ANGLE); // Ensure gate starts closed
  Serial.println("[SERVO] Gate initialized to CLOSED (0 deg).");

  // Connect Wi-Fi
  connectWiFi();

  // Connect Firebase
  initFirebase();
}

void loop() {
  // 1. Maintain Wi-Fi
  if (WiFi.status() != WL_CONNECTED) {
    connectWiFi();
  }

  // 2. Update Heartbeat to Firebase Realtime Database
  unsigned long now = millis();
  if (now - lastHeartbeatTime > HEARTBEAT_INTERVAL) {
    lastHeartbeatTime = now;
    updateHeartbeat();
  }

  // 3. Listen for Flutter App Commands
  checkGateCommands();

  delay(200); // Polling delay
}

void connectWiFi() {
  Serial.print("[WIFI] Connecting to ");
  Serial.println(WIFI_SSID);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 30) {
    delay(500);
    Serial.print(".");
    attempts++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WIFI] Connected! IP: " + WiFi.localIP().toString());
  } else {
    Serial.println("\n[WIFI] Connection failed. Retrying in loop...");
  }
}

void initFirebase() {
  Serial.println("[FIREBASE] Initializing Firebase RTDB client...");
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Set initial device status
  String path = "devices/" + String(DEVICE_ID) + "/system/";
  Firebase.setBool(firebaseData, path + "online", true);
  Firebase.setString(firebaseData, path + "firmwareVersion", "v1.0.4-ESP8266");

  // Set initial gate status
  String gatePath = "devices/" + String(DEVICE_ID) + "/gate/";
  Firebase.setString(firebaseData, gatePath + "status", "CLOSED");
  Firebase.setString(firebaseData, gatePath + "command", "CLOSE");
}

void updateHeartbeat() {
  if (WiFi.status() != WL_CONNECTED) return;

  String path = "devices/" + String(DEVICE_ID) + "/system/";
  unsigned long timestamp = millis();
  
  Firebase.setBool(firebaseData, path + "online", true);
  Firebase.setInt(firebaseData, path + "lastSeen", timestamp);
  
  Serial.println("[HEARTBEAT] Updated system/lastSeen: " + String(timestamp));
}

void checkGateCommands() {
  String path = "devices/" + String(DEVICE_ID) + "/gate";
  
  if (Firebase.getJSON(firebaseData, path)) {
    FirebaseJson &json = firebaseData.jsonObject();
    FirebaseJsonData cmdData, cmdIdData;

    json.get(cmdData, "command");
    json.get(cmdIdData, "commandId");

    if (cmdData.success && cmdIdData.success) {
      String command = cmdData.stringValue;
      String commandId = cmdIdData.stringValue;

      // Command Reliability Check: Ignore if command already executed
      if (commandId == lastProcessedCommandId || commandId == "") {
        return; 
      }

      Serial.println("[COMMAND] New command received: " + command + " (ID: " + commandId + ")");
      lastProcessedCommandId = commandId;

      String statusPath = "devices/" + String(DEVICE_ID) + "/gate/status";

      if (command == "OPEN" && currentGateStatus != "OPEN") {
        Serial.println("[SERVO] Opening gate slowly...");
        Firebase.setString(firebaseData, statusPath, "OPENING");
        
        moveServoSlowly(CLOSED_ANGLE, OPEN_ANGLE, 25); // Move slowly over ~2.2s
        
        currentGateStatus = "OPEN";
        Firebase.setString(firebaseData, statusPath, "OPEN");
        Serial.println("[SERVO] Gate fully OPEN.");

        // Record history log to Firebase
        String histPath = "devices/" + String(DEVICE_ID) + "/history/REC_" + String(millis());
        FirebaseJson histJson;
        histJson.add("title", "Manual / Scheduled Feeding");
        histJson.add("timestamp", millis());
        histJson.add("type", "Hardware");
        histJson.add("status", "Completed");
        histJson.add("durationSeconds", 15);
        Firebase.set(firebaseData, histPath, histJson);

      } else if (command == "CLOSE" && currentGateStatus != "CLOSED") {
        Serial.println("[SERVO] Closing gate slowly...");
        Firebase.setString(firebaseData, statusPath, "CLOSING");

        moveServoSlowly(OPEN_ANGLE, CLOSED_ANGLE, 25);

        currentGateStatus = "CLOSED";
        Firebase.setString(firebaseData, statusPath, "CLOSED");
        Serial.println("[SERVO] Gate fully CLOSED.");
      }
    }
  }
}

// Moves servo smoothly to prevent jerky movements
void moveServoSlowly(int startAngle, int targetAngle, int stepDelayMs) {
  if (startAngle < targetAngle) {
    for (int pos = startAngle; pos <= targetAngle; pos += 2) {
      gateServo.write(pos);
      delay(stepDelayMs);
    }
  } else {
    for (int pos = startAngle; pos >= targetAngle; pos -= 2) {
      gateServo.write(pos);
      delay(stepDelayMs);
    }
  }
}
