//
//  ContentView.swift
//  WordScramble
//
//  Created by Joe May on 02/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    var body: some View {
        NavigationStack{
            Section{
                Text("Your score is: \(score)")
                    .font(.headline)
                    .padding()
                
            }
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section{
                    ForEach(usedWords, id:\.self){word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle("\(rootWord)")
            .toolbar {
                Button("New Word", action: startGame)
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle ,isPresented: $showingError){
                Button("Ok"){}
            }message: {
                Text(errorMessage)
            }
                
            
        }
    }
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        guard isOriginal(word:answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        guard isPossible(word:answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognised", message: "You can't just make them up?")
            return
        }
        guard tooShort(word: answer) else{
            wordError(title: "Word is too short", message: "Must be longer then 3 letters")
            return
        }
        guard sameAsRootWord(word: answer) else{
            wordError(title: "Same as the root word", message: "Your going to have to try harder then that")
            return
        }
        
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        score = score + answer.count
        newWord = ""
    }
    func startGame() {
        score = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    func isOriginal(word:String) -> Bool {
        !usedWords.contains(word)
    }
    func isPossible(word:String) -> Bool{
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    func isReal(word:String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func wordError(title:String, message:String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    func tooShort(word:String) -> Bool{
        if word.count < 4 {
            return false
        }
        else {
            return true
        }
    }
    func sameAsRootWord(word:String) -> Bool{
        !(word == rootWord)
    }
}

#Preview {
    ContentView()
}
