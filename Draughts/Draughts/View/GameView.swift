//
//  GameVIew.swift
//  Draughts
//
//  Created by Dwayne Reinaldy on 4/20/22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var settings: Settings
    @ObservedObject var stats: Settings.Stats
    
    @Binding var isGame: Bool
    @State private var isWantToQuit = false
    @State private var isSheet = false
    @State private var isPause = false
    @State private var statsView = false
    
    @State private var board = Board()
    @State private var player: Player = .playerA
    @State private var timeRemaining = 30
    
    @State private var isWin = false
    @State private var steps = 0
    
    var gameWonBy: Player? {
        var playerB = 0
        var playerA = 0
        
        for node in board.array {
            if node.isWithCheck && node.player == .playerB && node.isAlive {
                playerB += 1
            }
            if node.isWithCheck && node.player == .playerA && node.isAlive {
                playerA += 1
            }
        }
        
        if playerB == 0 {
            return .playerA
        }
        
        if  playerA == 0 {
            return .playerB
        }
        
        return nil
    }
    
    var turnTime: Int {
        timeRemaining = settings.turnTime
        return timeRemaining
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if isGame {
            ZStack {
            // Back Ground Color
            Color(settings.darkMode ? "BgDark" : "BgLight").ignoresSafeArea()
            
                VStack {
                    Spacer()
                        .frame(height:30)
                    
                    HStack {
                        Button(action: {
                            isPause.toggle()
                            
                        }, label: {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .foregroundColor(Color(settings.darkMode ? "TextDark" : "TextLight"))
                                .frame(width: 45, height: 45)
                                .background(Color(settings.darkMode ? "ButtonDark" : "ButtonLight"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        })
                        .padding()
                        Spacer()
                            .frame(width:27)
                        
                        //  Represents current player
                        LargeTitle("Checkers", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight")).padding()
                        Spacer()
                    }
            
                    Spacer()
                        .frame(height:60)
                    
                    VStack(spacing: 0) {
                        ForEach(0..<8) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<8) { column in
                                    SquareView(node: board[column, row], settings: settings)
                                        .gesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    if board.move(to: board[column, row], as: player) {
                                                        player = player == .playerA ? .playerB : .playerA
                                                        timeRemaining = turnTime
                                                        steps += 1
                                                        playSound(sound: "chess", type: "wav")
                                                        if steps == 100 {
                                                            stats.tiesCount += 1
                                                            isWin.toggle()
                                                        }
                                                        
                                                        if let winner = gameWonBy {
                                                            stats.gamesCount += 1
                                                            stats.winsCount += winner == .playerA ?  1 : 0
                                                            stats.losesCount += winner == .playerB ? 1 : 0
                                                            isWin.toggle()
                                                            playSound(sound: "win", type: "wav")
                                                        }
                                                    }
                                                }
                                        )
                                }
                            }
                        }
                    }.animation(.linear)
                    LargeTitle("Time remaining: \(timeRemaining)", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight")).padding()
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                if isPause || statsView{
                                    timeRemaining -= 0
                                }
                                else{
                                 timeRemaining -= 1
                                }
                            }
                            else if timeRemaining == 0 {
                                player = player == .playerA ? .playerB : .playerA
                                timeRemaining = turnTime
                            }
                        }
                    LargeTitle("\(player.rawValue)'s Turn", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight")).padding()
                    
                }
                .blur(radius: isPause ? 10 : 0)
                .disabled(isPause ? true : false)
                .alert(isPresented: $isWin) {
                    Alert(title: Text(steps == 100 ? "TIE!" : "\(gameWonBy!.rawValue) WIN!"),
                          message: Text("Play again?"), dismissButton: .default(Text("Yes"), action: { board = Board(); timeRemaining = turnTime; steps = 0 }))
                }
                
                if isPause {
                    
                    // Pause Menu
                    VStack {
                        // Continue Button
                        RoundedButtonToggler<Capsule>("Continue",
                                                      fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                                      bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                                      width: 180,
                                                      hight: 40,
                                                      content: $isPause).padding(.bottom)
                            
                        // Restart Button
                        RoundedButton<Capsule>("Restart",
                                               fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                               bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                               width: 180,
                                               hight: 40,
                                               content: { board = Board(); isPause.toggle(); timeRemaining = turnTime; steps = 0 }).padding(.bottom)
                        
                        // Settings Button
                        RoundedButtonToggler<Capsule>("Settings",
                                               fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
                                               bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
                                               width: 180,
                                               hight: 40,
                                               content: $isSheet).padding(.bottom)
                            

                    }
                    .sheet(isPresented: $isSheet) {
                        SettingsView(settings: settings, fromGame: true)
                    }
                }
            }.ignoresSafeArea()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(settings: Settings(), stats: Settings.Stats(), isGame: .constant(true))
    }
}
