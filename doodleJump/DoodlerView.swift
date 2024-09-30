//
//  DoodlerView.swift
//  doodleJump
//
//  Created by Starfighter Dollie on 9/30/24.
//

import SwiftUI

struct DoodlerView: View {
    let height: Double
    var body: some View {
        Circle()
            .frame(height: height)
            .foregroundColor(.yellow)
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }
}

struct DoodlerView_Previews: PreviewProvider {
    static var previews: some View {
        DoodlerView(height: GameSettings.defaultSettings.doodlerHeight)
    }
}
