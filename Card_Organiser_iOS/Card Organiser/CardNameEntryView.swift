//
//  CardNameEntryView.swift
//  Card Organiser
//
//  Created by Weihang Huang on 18/9/2023.
//

import SwiftUI

struct CardNameEntryView: View {
    @Binding var cardName: String
    var slotIndex: Int
    var onSave: (Int, String) -> Void
    
    @State private var isButtonActive: Bool = false
    
    var body: some View {
        VStack(spacing: 20) { // adjusted spacing
            TextField("Enter card name here...", text: $cardName)
                .font(.title2)
                .padding()
                .foregroundColor(Color(UIColor.label)) // Adaptive text color
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.systemBackground)) // Adaptive background color
                                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 3))
                )
                .overlay(
                    HStack {
                        Spacer()
                        if !cardName.isEmpty {
                            Button(action: {
                                self.cardName = ""
                                self.isButtonActive = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .transition(.opacity)
                        }
                    }
                )
                .onAppear {
                    if cardName.lowercased() == "empty" {
                        self.cardName = ""
                    }
                }
            
            Button(action: {
                if !cardName.isEmpty && cardName.lowercased() != "empty" {
                    onSave(slotIndex, cardName)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            }) {
                Text("Save")
                    .foregroundColor(isButtonActive ? .white : .gray)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(isButtonActive ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(10)
            }
            .disabled(!isButtonActive)
            Spacer()
        }
        .navigationBarTitle("Edit Card Name", displayMode: .inline)
        .padding(.horizontal)
        .onChange(of: cardName) { newValue in
            isButtonActive = !newValue.isEmpty && newValue.lowercased() != "empty"
        }
    }
}




struct CardNameEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardNameEntryView(cardName: .constant("Test Card"), slotIndex: 0) { index, name in
                // Mock update action
            }
        }
    }
}

