# Smart Card Organizer

The Smart Card Organizer is a custom-built, automated system for managing and dispensing cards. Controlled through an iOS application, this project integrates with an ESP32 microcontroller and a combination of stepper and servo motors to handle card storage and retrieval. The modular design allows for customization to accommodate different card sizes/numbers and stepper motors.

## Watch the demo
[![Watch the demo](https://dropovercl.s3.amazonaws.com/788c3697-18a4-419a-a261-367eb79965e3/6454121c-67d5-4431-9e51-5877a0a7da7c/d1ba5ffc-214c-475d-a2b5-11c2a061eb09.jpg)](https://drive.google.com/file/d/1ij-SFkKw6bYUhhGNDE27DTrZ7SnRrTU6/view?usp=drive_link)

## Hardware Components

- ESP32 microcontroller
- 200-step stepper motor (12V/24V DC)
- Motor driver (e.g., A4988)
- Servo motor
- 12V/24V DC power supply

## Software Components

- iOS application (with Bluetooth management and UI)
- Arduino sketch for ESP32

## Installation

1. **Mechanical Setup:**
    - Assemble the card organizer according to the 3D printed model specifications.
    - Install the stepper motor and attach the rotating structure. Adjust the design for the number of card slots and card dimensions as needed.
    - Mount the servo motor and ensure the ejection stick is correctly aligned for smooth card ejection.
    - The base should be adjusted so that the height between the rotating structure and the servo ejection stick allows for correct card dispensing.

2. **Electronics Assembly:**
    - The ESP32 board and motor driver can be installed either as a separate unit or integrated with the main structure.
    - Ensure that the stepper motor is correctly connected to the motor driver, which in turn connects to the ESP32.

## Configuration

- Update the `serviceUUID` and `characteristicUUID` in both the iOS app’s Bluetooth manager and the ESP32 sketch so they match.
- Adjust the motor driver's VREF to the correct voltage as per the motor specifications and desired current.

## Troubleshooting

- **Card Ejection Issues:** If warping occurs due to the FDM printing process, heat a card to 90 degrees Celsius (using, for example, a 3D printer's bed) and insert it into the affected card slot. Allow it to cool down to reshape the slot.
- **Connectivity Problems:** Ensure that the UUIDs in the ESP32 and iOS app are correctly paired.
- **Motor Movement Errors:** Verify the VREF adjustment on the motor driver and check for proper electrical connections.

## Contributing

This project is currently a personal endeavor. While contributions are not actively sought at this time, feedback and suggestions are welcome. If you have ideas for improvements or have developed extensions for different use-cases, feel free to share your thoughts.

## License

This project is open-sourced under the MIT license. For more information, see [LICENSE](LICENSE).

## Acknowledgements

This project makes use of several open-source libraries and we are grateful to the community for maintaining them. Our sincere appreciation goes to the developers and contributors of the following libraries:

- [BLEDevice.h, BLEServer.h, BLEUtils.h, BLE2902.h](https://github.com/nkolban/ESP32_BLE_Arduino): These libraries allow the ESP32 to use Bluetooth Low Energy (BLE) to communicate with the iOS application. Thanks to Neil Kolban and the other contributors for providing a comprehensive BLE library for the ESP32.

- [AccelStepper.h](https://www.airspayce.com/mikem/arduino/AccelStepper/): Created by Mike McCauley, this library enables smooth acceleration and deceleration of stepper motors. It is an essential part of controlling the stepper motor in the card organizer system.

- [ESP32Servo.h](https://github.com/madhephaestus/ESP32Servo): A library which allows for an easy interface with servo motors on the ESP32 platform. This is crucial for operating the card ejection mechanism in our system.

We thank the maintainers for their dedication to the open-source community and for their contributions which have been invaluable to the development of the Smart Card Organizer.

