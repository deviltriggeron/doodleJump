//
//  ContentView.swift
//  doodleJump
//
//  Created by Starfighter Dollie on 9/30/24.
//

import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct ContentView: View {
    @State private var doodlerYPosition = 0.0
    @State private var doodlerXPosition = 0.0
    @State private var platforms: [Platform] = []
    @State private var gameState: GameState = .ready
    @State private var doodlerYVelocity = 0.0
    @State private var doodlerXVelocity = 0.0
    
    @State private var doodlerXAcceleration = 0.0
    @State private var score = 0
    @AppStorage(wrappedValue: 0, "highScore") private var highScore: Int
    
    private let settings = GameSettings.defaultSettings
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Text(score.formatted())
                    .font(.title)
                    .padding()
                    .foregroundColor(.black)
                    .position(x: 60, y: 60)
                
                ForEach(platforms.indices, id:\.self) { index in
                    let platform = platforms[index]
                    
                    if platform.isVisible {
                        PlatformView(width: settings.platformWidth, height: settings.platformHeight, platformType: platform.type)
                            .position(x: platform.positionX, y: platform.positionY)
                    }
                }
                
                
                DoodlerView(height: settings.doodlerHeight)
                    .scaleEffect(x: doodlerXVelocity > 0 ? 1 : -1)
                    .position(x: doodlerXPosition, y: doodlerYPosition)
                
                if gameState == .ready {
                    Button(action: playButtonActive) {
                        Image(systemName: "play.fill")
                            .scaleEffect(x: 3.5, y: 3.5)
                    }
                    .foregroundColor(.blue)
                }
                
                if gameState == .stopped {
                    ResultView(score: score, highScore: highScore) {
                        resetGame(geometry: geometry)
                    }
                }
            }
            .background(Image(.background))
            .ignoresSafeArea()
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            doodlerXAcceleration = settings.accelarationRate
                        } else if value.translation.width < 0 {
                            doodlerXAcceleration = -settings.accelarationRate
                        }
                    }
                    .onEnded { _ in
                        doodlerXAcceleration = 0.0
                    }
            )
            .onAppear {
                resetGame(geometry: geometry)
                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                    guard gameState == .active else { return }
                    applyGravity()
                    limitFallToBottomEdge()
                    handleScrolling()
                    updatePlatforms(to: height)
                    applyHorizontalMovement(width: width)
                }
            }
        }
    }
}


// MARK: - Gravity and movement
private extension ContentView {
    func applyGravity() {
        if !isOnPlatform() {
            doodlerYVelocity += settings.gravity
        }
        doodlerYPosition += doodlerYVelocity
    }
    
    func limitFallToBottomEdge() {
        if doodlerYPosition > UIScreen.main.bounds.height {
            doodlerYPosition = UIScreen.main.bounds.height
            gameState = .stopped
        }
    }
    
    func applyHorizontalMovement(width: Double) {
        doodlerXVelocity += doodlerXAcceleration
        doodlerXVelocity = min(max(doodlerXVelocity, -settings.maxVelocity), settings.maxVelocity)
        if doodlerXAcceleration == 0 {
            doodlerXVelocity *= settings.deceleratioinRate
        }
        
        doodlerXPosition += doodlerXVelocity
        
        if doodlerXPosition < -settings.doodlerHeight / 2 {
            doodlerXPosition = width + settings.doodlerHeight / 2
        } else if doodlerXPosition > width + settings.doodlerHeight / 2 {
            doodlerXPosition = -settings.doodlerHeight / 2
        }
    }
}


// MARK: Platform managment
private extension ContentView {
    private func isOnPlatform() -> Bool {
        for index in platforms.indices {
            let platform = platforms[index]
            
            if doodlerYPosition + settings.doodlerHeight / 2 > platform.positionY - settings.platformHeight / 2 &&
                doodlerYPosition + settings.doodlerHeight / 2 < platform.positionY + settings.platformHeight / 2 && doodlerXPosition > platform.positionX - settings.platformWidth / 2 && doodlerXPosition < platform.positionX + settings.platformWidth && doodlerYVelocity > 0 && platform.isVisible {
                if platform.type == .disappearingPlatform {
                    platforms[index].isVisible = false
                }
                doodlerYVelocity = settings.jumpVelocity
                return true
            }
        }
        return false
    }
    
    func handleScrolling() {
        if doodlerYVelocity < 0 && doodlerYPosition < settings.scroolThreshold {
            let offset = settings.scroolThreshold - doodlerYPosition
            doodlerYPosition = settings.scroolThreshold
            
            for index in platforms.indices {
                platforms[index].positionY += offset
            }
            updateScoreAfterScrolling(offset: offset)
        }
    }
    
    func updatePlatforms(to height: Double) {
        updateMovingPlatforms()
        
        platforms.removeAll { $0.positionY > height + settings.platformHeight || !$0.isVisible }
        
        while platforms.count < 5 {
            let newPlatformY = (platforms.min { $0.positionY < $1.positionY}?.positionY ?? height) - Double.random(in: 80...100)
            let newPlatformType: PlatformType = [.staticPlatform, .movingPlatform, .disappearingPlatform].randomElement()!
            platforms.append(Platform(positionY: newPlatformY, positionX: Double.random(in: 50...350), type: newPlatformType))
        }
    }
    
    func updateMovingPlatforms() {
        for index in platforms.indices {
            if platforms[index].type == .movingPlatform {
                platforms[index].positionX += 2.0
                if platforms[index].positionX > 350 {
                    platforms[index].positionX = 50
                }
            }
        }
    }
    
}


// MARK: Game state managment
private extension ContentView {
    func playButtonActive() {
        gameState = .active
    }
    
    func resetGame(geometry: GeometryProxy) {
        doodlerYPosition = geometry.size.height * 2 / 3
        doodlerXPosition = geometry.size.width / 2
        doodlerYVelocity = 0
        doodlerXVelocity = 0
        doodlerXAcceleration = 0
        
        platforms = [Platform(positionY: doodlerYPosition + 50, positionX: geometry.size.width / 2, type: .staticPlatform),
                     Platform(positionY: doodlerYPosition - 90, positionX: geometry.size.width / 2, type: .staticPlatform),
                     Platform(positionY: doodlerYPosition - 200, positionX: geometry.size.width / 2, type: .staticPlatform)]
        
        score = 0
        gameState = .ready
    }
}


// MARK: - Scoring
private extension ContentView {
    func updateScoreAfterScrolling(offset: Double) {
        score += Int(offset)
        
        if score > highScore {
            highScore = score
        }
    }
}

#Preview {
    ContentView()
}
