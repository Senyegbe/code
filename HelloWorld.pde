#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN 9    // Connect RST pin on RFID module to digital pin 9
#define SS_PIN 10    // Connect SS pin on RFID module to digital pin 10
#define IRQ_PIN 2    // Connect IRQ pin on RFID module to digital pin 2

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create an instance of the RFID library

void setup() {
  Serial.begin(9600);
  SPI.begin();      // Initiate SPI bus
  mfrc522.PCD_Init(); // Initiate MFRC522 RFID library
  pinMode(IRQ_PIN, INPUT_PULLUP);  // Set IRQ pin as input with internal pull-up resistor
}

void loop() {
  // Look for new cards
  if (digitalRead(IRQ_PIN) == LOW) {
    // Create an instance of the RFID card
    MFRC522::Uid uid;
    
    // Wait for a card to be present
    if (mfrc522.PICC_IsNewCardPresent() && mfrc522.PICC_ReadCardSerial()) {
      // Read the card's UID
      uid = mfrc522.uid;
      
      // Print the UID to the serial monitor
      Serial.print("Card UID: ");
      for (byte i = 0; i < uid.size; i++) {
        Serial.print(uid.uidByte[i] < 0x10 ? " 0" : " ");
        Serial.print(uid.uidByte[i], HEX);
      }
      Serial.println();

      // Halt and stop crypto
      mfrc522.PICC_HaltA();
      mfrc522.PCD_StopCrypto1();
    }
  }
}
