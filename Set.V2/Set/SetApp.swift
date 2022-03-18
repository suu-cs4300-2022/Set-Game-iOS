//
//  SetApp.swift
//  Set
//
//  Created by Kai Cottrell on 2/20/22.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetView(game: game)
        }
    }
}
