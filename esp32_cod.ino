#include <Arduino.h>
#include <WiFi.h>
#include <Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <Firebase_ESP_Client.h>

#define WIFI_SSID "Samsung_S21_Andrei"
#define WIFI_PASSWORD "andrei123"

#define API_KEY "AIzaSyBYADy57xhFgkRschZrzgu6TAQ2RtKIzPk"
#define FIREBASE_PROJECT_ID "bookmylook-8281b"
#define DATABASE_URL "https://bookmylook-8281b.firebaseio.com/"
#define FIREBASE_EMAIL "admin@bookmylook.com"
#define FIREBASE_PASSWORD "admin1234"

PN532_I2C pn532_i2c(Wire);
PN532 nfc(pn532_i2c);

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

uint8_t authorizedUid[] = {0xF4, 0xF7, 0x77, 0x06};

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("\n\n========== BOOT ESP32 ==========");

  // 1. Inițializare I2C
  Wire.begin(21, 22);
  
  nfc.begin();
  uint32_t versiondata = nfc.getFirmwareVersion();
  if (!versiondata) {
    Serial.println("❌ PN532 NFC READER NU A FOST GĂSIT!");
    while (1);
  }
  Serial.println("✅ PN532 găsit: " + String(versiondata, HEX));
  nfc.SAMConfig();

  Serial.print("\n📡 Conectare WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int timeout = 0;
  while (WiFi.status() != WL_CONNECTED && timeout < 20) {
    Serial.print(".");
    delay(500);
    timeout++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n✅ WiFi conectat!");
  } else {
    Serial.println("\n❌ WiFi neconectat!");
    while (1);
  }

  // 3. Firebase Configuration
  Serial.print("\n🔐 Configurare Firebase...");
  
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  auth.user.email = FIREBASE_EMAIL;
  auth.user.password = FIREBASE_PASSWORD;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  Serial.println("\n✅ Firebase configurat!");
  Serial.println("========== READY TO SCAN ==========\n");
}

bool scanCard() {
  uint8_t scannedUid[7];
  uint8_t uidLength;
  
  if (nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, scannedUid, &uidLength)) {
    bool isMatch = true;
    for (uint8_t i = 0; i < 4; i++) {
      if (scannedUid[i] != authorizedUid[i]) {
        isMatch = false;
        break;
      }
    }
    return isMatch;
  }
  return false;
}

void updateFirebaseStatus() {
  String jsonPayload = R"({
    "fields": {
      "isScanned": {
        "booleanValue": true
      }
    }
  })";

  Serial.println("\n📤 Trimitere update Firebase...");
  
  if (Firebase.Firestore.patchDocument(
      &fbdo, 
      FIREBASE_PROJECT_ID,
      "",
      "hardware_sync/status",
      jsonPayload.c_str(),
      "isScanned"
  )) {
    Serial.println("✅ Firebase actualizat!");
  } else {
    Serial.println("❌ Eroare Firebase: " + fbdo.errorReason());
  }
}

void loop() {
  if (scanCard()) {
    Serial.println("\nCARD AUTORIZAT DETECTAT!");
    updateFirebaseStatus();
    
    delay(3000);
    Serial.println("Aștept alte carduri...");
  }
  
  delay(250);
}