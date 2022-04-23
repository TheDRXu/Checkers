//
//  SettingsView.swift
//  Draughts
//
//  Created by Dwayne Reinaldy on 4/20/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: Settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var fromGame = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Back Ground Color
                Color(settings.darkMode ? "BgDark" : "BgLight")
                
                VStack {
                    
                    Form {
                        
                        // Toggle dark mode
                        Section {
                            Toggle("Dark mode", isOn: $settings.darkMode)
                        }
                        .rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                  font: Font.system(.body).weight(.bold))
                        
                        // Choose turn time
                        Section {
                            Stepper("Turn time: \(settings.turnTime) sec.", onIncrement: {
                                if settings.turnTime < 300 {
                                    settings.turnTime += 10
                                }
                                
                            }, onDecrement: {
                                if settings.turnTime > 0 {
                                    settings.turnTime -= 10
                                }
                            })
                            .accentColor(.green)
                        }
                        .rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                  font: Font.system(.body).weight(.bold))
                        
                        // Section enables when view was invoked from the GameView
                        if fromGame {
                            Section {
                                HStack {
                                    Spacer()
                                    
                                    // State when settings were invoked from the GameView
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                        
                                    }, label: {
                                        Text("Back")
                                    })
                                    
                                    Spacer()
                                }
                            }.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                       rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                       font: Font.system(.body).weight(.heavy))
                        }
                    }
                    .foregroundColor(Color(settings.darkMode ? "TextDark" : "TextLight"))
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
            }
            .ignoresSafeArea()
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Custom title at the NavigationView
                    LargeTitle("Settings", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight"))
                }
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: Settings())
    }
}
