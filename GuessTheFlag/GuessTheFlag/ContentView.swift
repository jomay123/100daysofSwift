//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Joe May on 22/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
   @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var highScore = 0
    @State private var newHighScore = false
    @State private var animationAmount = 0.0


    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: Color(red:0.1, green:0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing:15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){number in
                        Button{
                            withAnimation{
                                flagTapped(number)
                                animationAmount += 360
                            }
                        }label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 0.5)
                        }
                        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius:20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text("Highscore: \(highScore)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text("""
High score: \(highScore)
Your score is \(score)
"""
            )
            
            
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            score = score + 1
            if score > highScore {
                highScore = score
                newHighScore = true
            }
        }
        else {
            scoreTitle = "Game over"
            score = 0
            showingScore = true
            if newHighScore{
                scoreTitle = """
Game over
New High Score !!!
"""
            }
        }
            showingScore = true
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    }


#Preview {
    ContentView()
}
