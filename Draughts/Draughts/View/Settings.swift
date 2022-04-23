//
//  Settings.swift
//  Draughts
//
//  Created by Dwayne Reinaldy on 4/20/22.
//

import Foundation

class Settings: ObservableObject {
    
    
    @Published var turnTime: Int = 30
    @Published var darkMode = true
    
    class Stats: ObservableObject {
        
        @Published var gamesCount = 0
        @Published var winsCount = 0
        @Published var losesCount = 0
        @Published var tiesCount = 0
    }
    
    func setToDefault() {
        turnTime = 30
        darkMode = true
    }
}


