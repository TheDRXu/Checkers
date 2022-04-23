//
//  DraughtsApp.swift
//  Draughts
//
//  Created by Dwayne Reinaldy on 4/20/22.
//

import SwiftUI

@main
struct DraughtsApp: App {
    var body: some Scene {
		WindowGroup {
            GameView(settings: Settings(), stats: Settings.Stats(), isGame: .constant(true))
        }
    }
}
