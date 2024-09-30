//
//  GameSettings.swift
//  doodleJump
//
//  Created by Starfighter Dollie on 9/30/24.
//

struct GameSettings {
    let doodlerHeight: Double
    let platformWidth: Double
    let platformHeight: Double
    let gravity: Double
    let jumpVelocity: Double
    let scroolThreshold: Double
    let maxVelocity: Double
    let accelarationRate: Double
    let deceleratioinRate: Double
    
    static var defaultSettings: GameSettings {
        GameSettings(doodlerHeight: 50.0,
                     platformWidth: 100.0,
                     platformHeight: 20.0,
                     gravity: 0.5,
                     jumpVelocity: -12.0,
                     scroolThreshold: 400.0,
                     maxVelocity: 10.0,
                     accelarationRate: 0.5,
                     deceleratioinRate: 0.98)
    }
}
