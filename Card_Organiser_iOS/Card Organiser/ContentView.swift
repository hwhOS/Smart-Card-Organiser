import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var selectedSlot: Int?
    @State private var currentCardName: String = ""
    @State private var showingDetail = false
    @State private var searchText: String = ""
    var emptySlotsCount: Int {
        return bluetoothManager.cardSlots.filter { $0 == "Empty" }.count
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()

                    Text(bluetoothManager.isConnected ? "Connected" : "Not Connected")
                        .foregroundColor(bluetoothManager.isConnected ? .green : .red)
                        .padding(.all, 5)
                        .background(bluetoothManager.isConnected ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .cornerRadius(5)
                    
                    Spacer()
                    
                    Text("\(emptySlotsCount) Empty Slots")
                        .padding(.all, 5)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)

                
                TextField("Search...", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                
                List(0..<20) { index in
                    if bluetoothManager.cardSlots[index].lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                        HStack {
                            Text("\(index + 1)")
                            Spacer()
                            Text(bluetoothManager.cardSlots[index])
                                .bold()
                                .foregroundColor(bluetoothManager.cardSlots[index] == "Empty" ? .gray : .primary)
                        }
                        .contentShape(Rectangle())
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                self.selectedSlot = index
                                self.showingDetail = true
                            }
                            .tint(.blue)
                            
                            Button("Clear") {
                                bluetoothManager.updateCardName(forSlot: index, name: "Empty")
                            }
                            .tint(.gray)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Pop Out") {
                                // Send the "Pop Out" command for the slot
                                print("Pop Out triggered for slot: \(index)")
                                bluetoothManager.sendSlotNumber(index, isPopOut: true)
                            }
                            .tint(.red)
                            
                            Button("Put In") {
                                // Send the "Put In" command for the slot
                                print("Put In triggered for slot: \(index)")
                                bluetoothManager.sendSlotNumber(index, isPopOut: false)
                            }
                            .tint(.green)
                        }


                    }
                }
            }
            .onChange(of: showingDetail) { newValue in
                if newValue, let slot = selectedSlot {
                    currentCardName = bluetoothManager.cardSlots[slot]
                }
            }
            .sheet(isPresented: $showingDetail) {
                if let slot = self.selectedSlot {
                    NavigationView {
                        CardNameEntryView(cardName: $currentCardName, slotIndex: slot) { index, name in
                            bluetoothManager.updateCardName(forSlot: index, name: name)
                            self.showingDetail = false
                        }
                    }
                }
            }
            .navigationBarTitle("Card Organizer", displayMode: .inline)
        }
    }
}








struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothManager: mockBluetoothManager())
    }
    
    static func mockBluetoothManager() -> BluetoothManager {
        let manager = BluetoothManager()
        //
        manager.cardSlots = ["Card 1", "Card 2", "Card 3", "Empty", "Empty", "Card 6", "Empty", "Card 8", "Card 9", "Empty", "Card 11", "Empty", "Empty", "Card 14", "Empty", "Card 16", "Card 17", "Card 18", "Card 19", "Empty"]
        return manager
    }
}

