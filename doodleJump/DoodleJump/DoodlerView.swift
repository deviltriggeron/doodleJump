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
        Image(.doodler)
            .resizable()
            .frame(width: height, height: height)
    }
}

struct DoodlerView_Previews: PreviewProvider {
    static var previews: some View {
        DoodlerView(height: GameSettings.defaultSettings.doodlerHeight)
    }
}
