#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <AccelStepper.h>
#include <ESP32Servo.h>

#define DIR_PIN 2 // Direction Pin
#define STEP_PIN 4 // Step Pin
#define SERVO_PIN 13 // Servo Pin
#define STEPS_PER_REVOLUTION 200 // for full stepping

AccelStepper stepper(AccelStepper::DRIVER, STEP_PIN, DIR_PIN);
Servo myservo;  // create servo object to control a servo

// Replace with your UUIDs
#define SERVICE_UUID "caba6f20-6054-11ee-8c99-0242ac120002"
#define CHARACTERISTIC_UUID "d6668386-6054-11ee-8c99-0242ac120002"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println("Device Connected");
    }

    void onDisconnect(BLEServer* pServer) {
        Serial.println("Device Disconnected");
        pServer->getAdvertising()->start(); // Start advertising again after a disconnect
    }
};


void loop() {

}

class MyCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    if (value.length() >= 2) { // make sure that we received at least 2 bytes
      uint8_t action = value[0]; // get the first byte
      uint8_t slot = value[1]; // get the second byte
      
      Serial.println("*********");
      Serial.print("Slot Index: ");
      Serial.println(slot); 
      Serial.println(action == 1 ? "Action: Pop Out" : "Action: Put In");
      Serial.println("*********");

      myservo.write(0);
      delay(1500); // Give the servo time to move back to 0 degrees.

      int stepsToMove = STEPS_PER_REVOLUTION / 20 * slot; // Calculate number of steps for the desired slot
      stepper.moveTo(stepsToMove); // Move stepper to the calculated position.
      
      while (stepper.distanceToGo() != 0) {
        stepper.run();
      }

      delay(1000);  // Wait for 1 second after the stepper has finished moving

      // After the stepper motor reaches its position, operate the servo.
      if (action == 1) {
        myservo.write(90); // Rotate servo to 90 degrees
        delay(1000); // Give the servo time to complete its action
      }
    }
  }
};


void setup() {
  Serial.begin(115200);
  stepper.setMaxSpeed(500);
  stepper.setAcceleration(250);
  myservo.attach(SERVO_PIN);  // attaches the servo on pin 9 to the servo object
  myservo.write(0); // Servo initial position
  stepper.setCurrentPosition(0); // Set stepper's current position to 0
  Serial.println("Hello, World!");

  // Create the BLE Device
  BLEDevice::init("ESP32_Card_Organizer");

  // Create the BLE Server
  BLEServer *pServer = BLEDevice::createServer();

  // Set the server callbacks
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ   |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  pCharacteristic->setCallbacks(new MyCallbacks());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}


