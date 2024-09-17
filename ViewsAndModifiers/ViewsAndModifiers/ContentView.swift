//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Joe May on 22/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var choices = ["🪨", "📄", "✂️"].shuffled()
    @State private var shouldWin = true
    @State private var correctChoice = Int.random(in:0...2)
    @State private var score = 0
    @State private var gameOver = false
    @State private var endScore = 0
    var tooBad = "Game Over!"
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                if shouldWin {
                    Text("Choose the option that beats \(choices[correctChoice])")
                        .font(.largeTitle.weight(.bold))
                    
                    Spacer()
                }
                else {
                    Text("Choose the option that loses to \(choices[correctChoice])")
                        .font(.largeTitle.weight(.bold))
                    Spacer()
                }
                
                HStack(spacing:50){
                    ForEach(0..<3){ number in
                        Button{
                            buttonPressed(number)
                        }label: {
                            Text("\(choices[number])")
                        }
                        
                        
                    }
                }
                
                Text("Your score is: \(score)")
                    .font(.subheadline.weight(.bold))
                Spacer()
            }
            .alert(tooBad, isPresented: $gameOver){
                Button("Continue"){
                    
                }
            }message: {
                Text("Your score was \(endScore)")
            }
        }
    }
    func buttonPressed(_ number: Int){
        if shouldWin{
            if choices[correctChoice] == "🪨" && choices[number] == "📄"{
                score = score + 1
            }
            else if choices[correctChoice] == "📄" && choices[number] == "✂️"{
                score = score + 1
            }
            else if choices[correctChoice] == "✂️" && choices[number] == "🪨"{
                score = score + 1
            }
            else {
                endScore = score
                score = 0
                gameOver.toggle()

            }
        }
        else {
            if choices[correctChoice] == "🪨" && choices[number] == "✂️"{
                score = score + 1
            }
            else if choices[correctChoice] == "📄" && choices[number] == "🪨"{
                score = score + 1
            }
            else if choices[correctChoice] == "✂️" && choices[number] == "📄"{
                score = score + 1
            }
            else {
                endScore = score
                score = 0
                gameOver.toggle()
            }
        }
        shouldWin.toggle()
        choices.shuffle()
    }
        
}



#Preview {
    ContentView()
}

