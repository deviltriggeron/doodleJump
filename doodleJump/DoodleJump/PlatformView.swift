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
    let platformType: PlatformType
    var body: some View {
        Image(platformType == .disappearingPlatform ? .platformYellow : .platformGreen)
            .resizable()
            .frame(width: width, height: height)
    }
}

struct PlatformView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformView(width: GameSettings.defaultSettings.platformWidth,
                     height: GameSettings.defaultSettings.platformHeight,
                     platformType: .staticPlatform
        )
    }
}
