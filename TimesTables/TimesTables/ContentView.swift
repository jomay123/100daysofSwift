import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var selectedTable = 2
    @State private var numberOfQuestions = 5
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showScore = false

    var body: some View {
        NavigationView {
            if !isActive {
                Form {
                    Section(header: Text("Settings")) {
                        Picker("Select multiplication table", selection: $selectedTable) {
                            ForEach(2..<13) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        Picker("Number of questions", selection: $numberOfQuestions) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("20").tag(20)
                        }
                    }
                    
                    Button("Start Game") {
                        startGame()
                    }
                }
                .navigationTitle("Multiplication Practice")
            } else {
                if showScore {
                    VStack(spacing: 20) {
                        Text("Game Over")
                        Text("Your score: \(score)/\(numberOfQuestions)")
                        Button("Play Again") {
                            startGame()
                        }
                    }
                } else {
                    QuestionView(question: questions[currentQuestionIndex], userAnswer: $userAnswer) { isCorrect in
                        if isCorrect { score += 1 }
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                        } else {
                            showScore = true
                        }
                    }
                }
            }
        }
    }
    
    func startGame() {
        questions = generateQuestions(for: selectedTable, count: numberOfQuestions)
        currentQuestionIndex = 0
        score = 0
        userAnswer = ""
        showScore = false
        isActive = true
    }
    
    func generateQuestions(for table: Int, count: Int) -> [Question] {
        var questions: [Question] = []
        for _ in 1...count {
            let number = Int.random(in: 1...12)
            let questionText = "\(table) x \(number)"
            let questionAnswer = table * number
            questions.append(Question(text: questionText, answer: questionAnswer))
        }
        return questions
    }
}

struct QuestionView: View {
    let question: Question
    @Binding var userAnswer: String
    let onAnswerSubmitted: (Bool) -> Void
    
    var body: some View {
        VStack {
            Text(question.text)
                .font(.largeTitle)
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            Button("Submit") {
                let isCorrect = Int(userAnswer) == question.answer
                onAnswerSubmitted(isCorrect)
                userAnswer = ""
            }
        }
        .padding()
    }
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let answer: Int
}


