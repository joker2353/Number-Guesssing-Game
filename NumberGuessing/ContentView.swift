import SwiftUI

struct ContentView: View {
    @State private var randomNumber = Int.random(in: 1...100)
    @State private var guess = ""
    @State private var feedback = "Guess a number between 1 and 100"
    @State private var attempts = 0
    @State private var maxAttempts = 10
    @State private var gameIsActive = true
    @State private var showCelebration = false
    @State private var hint = ""

    var body: some View {
        
        ZStack {
            Image("background-wood-cartoon")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Number Guessing Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Text(feedback)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(feedbackColor())
                    .padding()
                
                if gameIsActive {
                    Text("Attempts: \(attempts) / \(maxAttempts)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                
                TextField("Enter your guess", text: $guess)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!gameIsActive)
                
                if !hint.isEmpty {
                    Text("Hint: \(hint)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.bottom, 10)
                }
                
                Button(action: {
                    checkGuess()
                }) {
                    Text("Submit Guess")
                        .padding()
                        .background(gameIsActive ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!gameIsActive)
                .padding()
                
                Button(action: {
                    resetGame()
                }) {
                    Text("Play Again")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    giveHint()
                }) {
                    Text("Get a Hint")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!gameIsActive || attempts < 3)
                .padding()
                
                if showCelebration {
                    Text("🎉🎉🎉")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .transition(.scale)
                        .foregroundColor(.yellow)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
    }
    
    func checkGuess() {
        guard let guessNumber = Int(guess), guessNumber >= 1, guessNumber <= 100 else {
            feedback = "Please enter a valid number between 1 and 100"
            return
        }
        
        attempts += 1
        hint = ""
        
        if guessNumber < randomNumber {
            feedback = "Lower! Try again."
        } else if guessNumber > randomNumber {
            feedback = "Higher! Try again."
        } else {
            feedback = "🎉 Correct! You guessed the number in \(attempts) attempts!"
            gameIsActive = false
            showCelebration = true
        }
        
        if attempts == maxAttempts && gameIsActive {
            feedback = "Game Over! The number was \(randomNumber). Try again!"
            gameIsActive = false
        } else if attempts % 5 == 0 && gameIsActive {
            feedback = "Keep going! You're getting closer!"
        }
        
        guess = ""
    }
    
    func giveHint() {
        guard let guessNumber = Int(guess), guessNumber >= 1, guessNumber <= 100 else {
            hint = "Please enter a guess first!"
            return
        }
        
        let difference = abs(randomNumber - guessNumber)
        
        if difference > 50 {
            hint = "Very far off"
        } else if difference > 20 {
            hint = "Somewhat far"
        } else if difference > 10 {
            hint = "Close!"
        } else {
            hint = "Very close!"
        }
    }
    
    func feedbackColor() -> Color {
        guard let guessNumber = Int(guess) else { return .white }
        
        let difference = abs(randomNumber - guessNumber)
        
        if difference > 50 {
            return .red
        } else if difference > 20 {
            return .orange
        } else {
            return .green
        }
    }
    
    func resetGame() {
        randomNumber = Int.random(in: 1...100)
        guess = ""
        feedback = "Guess a number between 1 and 100"
        attempts = 0
        gameIsActive = true
        showCelebration = false
        hint = ""
    }
}
