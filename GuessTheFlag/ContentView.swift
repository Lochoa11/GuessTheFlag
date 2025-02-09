//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lin Ochoa on 11/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stipe red.",
        "Spain": "Flag with three horizontal Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
    
    @State private var finalMessage = ""
    @State private var finalTitle = ""
    @State private var questionCount = 0
    @State private var showingFinal = false
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var isShowingWrongFlags = true
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    struct Title: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .foregroundStyle(.white)
                .padding()
                .background(.blue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops:[
                .init(color: Color(red:0.1, green:0.2, blue:0.45), location: 0.3),
                .init(color: Color(red:0.76, green:0.15, blue:0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .modifier(Title())
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        if isShowingWrongFlags || number == correctAnswer {
                            Button {
                                flagTapped(number)
                                withAnimation {
                                    animationAmount += 360
                                    isShowingWrongFlags = false
                                }
                                opacity = 0.3
                            } label: {
                                FlagImage(country: countries[number])
                                    .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            }
                            .rotation3DEffect(.degrees(number == correctAnswer ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                            .opacity(number != correctAnswer ? opacity : 1)
                            .transition(.scale)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()

                Text("Score \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(message)
        }
        .alert(finalTitle, isPresented: $showingFinal) {
            Button("Continue", action: restart)
        } message: {
            Text(finalMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            message = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            message = "Wrong that's the flag of \(countries[number])"
        }
                
        questionCount += 1

        if questionCount == 8 {
            finalTitle = "Final Score"
            finalMessage = "You got \(score) out of 8 correct!"
            showingFinal = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacity = 1.0
        isShowingWrongFlags = true
    }
    
    func restart() {
        score = 0
        questionCount = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
