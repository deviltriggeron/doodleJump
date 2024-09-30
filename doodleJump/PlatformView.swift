//
//  PlatformView.swift
//  doodleJump
//
//  Created by Starfighter Dollie on 9/30/24.
//

import SwiftUI

struct PlatformView: View {
    let width: Double
    let height: Double
    var body: some View {
        Capsule()
            .frame(width: width, height: height)
            .foregroundStyle(.green)
    }
}

struct PlatformView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformView(width: GameSettings.defaultSettings.platformWidth,
                     height: GameSettings.defaultSettings.platformHeight
        )
    }
}
