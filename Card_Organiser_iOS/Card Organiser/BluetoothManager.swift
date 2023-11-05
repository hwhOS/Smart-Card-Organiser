import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    @Published var isConnected: Bool = false  // property to hold the connection status
    @Published var cardSlots: [String] = Array(repeating: "Empty", count: 20)

    override init() {
        super.init()
        loadCardSlots()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    // properties for the service UUID and characteristic UUID
    let serviceUUID = CBUUID(string: "caba6f20-6054-11ee-8c99-0242ac120002")
    let characteristicUUID = CBUUID(string: "d6668386-6054-11ee-8c99-0242ac120002")
    var targetCharacteristic: CBCharacteristic?

    // after connecting to a peripheral, discover its services
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.name == "ESP32_Card_Organizer" {
            self.peripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral). \(error?.localizedDescription ?? "")")
        self.isConnected = false
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            self.isConnected = false
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        self.isConnected = true  // Update the connection status
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }

    // After discovering services, you should discover the characteristics of your service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            print("No Services Discovered!")
            return
        }
        
        for service in services {
            print("Service found with UUID: \(service.uuid)")
            
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("No Characteristics Discovered for service: \(service.uuid)")
            return
        }
        
        for characteristic in characteristics {
            print("Characteristic found with UUID: \(characteristic.uuid)")
            
            if characteristic.uuid == characteristicUUID {
                targetCharacteristic = characteristic
            }
        }
    }

    func sendSlotNumber(_ slot: Int, isPopOut: Bool) {
        guard let characteristic = targetCharacteristic else {
            print("Characteristic is nil. Cannot send data.")
            return
        }
        
        let actionByte: UInt8 = isPopOut ? 1 : 0 // 1 for Pop Out, 0 for Put In
        let slotByte: UInt8 = UInt8(slot)
        
        let data = Data([actionByte, slotByte])
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }


    
    // Load stored card slots or initialize with default values
    func loadCardSlots() {
        if let savedSlots = UserDefaults.standard.array(forKey: "cardSlots") as? [String] {
            cardSlots = savedSlots
        } else {
            // Initialize with default values if no saved data is found
            cardSlots = Array(repeating: "Empty", count: 20)
        }
    }

    // Save card slots
    func saveCardSlots() {
        UserDefaults.standard.set(cardSlots, forKey: "cardSlots")
    }

    func updateCardName(forSlot index: Int, name: String) {
        cardSlots[index] = name
        saveCardSlots()
    }
}
