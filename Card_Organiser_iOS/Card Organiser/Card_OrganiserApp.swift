//
//  Card_OrganiserApp.swift
//  Card Organiser
//
//  Created by Weihang Huang on 18/9/2023.
//

import SwiftUI

@main
struct Card_OrganiserApp: App {
    var bluetoothManager = BluetoothManager()

    var body: some Scene {
        WindowGroup {
            ContentView(bluetoothManager: bluetoothManager)
                .environmentObject(bluetoothManager)
        }
    }
}
