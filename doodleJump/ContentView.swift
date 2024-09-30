//
//  ContentView.swift
//  doodleJump
//
//  Created by Starfighter Dollie on 9/30/24.
//

import SwiftUI

struct ContentView: View {
    @State private var doodlerYPosition = 500.0
    @State private var platform = [200.0, 400, 600]
    private let settings = GameSettings.defaultSettings
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                ForEach(platform, id:\.self) { platformY in
                    PlatformView(width: settings.platformWidth, height: settings.platformHeight)
                        .position(x: width / 2, y: platformY)
                }
               
                DoodlerView(height: settings.doodlerHeight)
                    .position(x: width / 2, y: doodlerYPosition)
            }
            .background(.blue.opacity(0.1))
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
