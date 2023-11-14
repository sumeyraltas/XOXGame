import SwiftUI

enum Player: String {
    case x = "X"
    case o = "O"
}

struct ContentView: View {
    @State private var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @State private var currentPlayer: Player = .x
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var otherPlayer: Player {
        return (currentPlayer == .x) ? .o : .x
    }

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.system(size: 30, weight: .bold))
                .padding(50)
            Spacer()
            VStack(spacing: 5) {
                ForEach(0..<3) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<3) { col in
                            Button(action: {
                                if board[row][col] == nil {
                                    board[row][col] = currentPlayer
                                    checkForWinner()
                                    switchPlayer()
                                }
                            }) {
                                Text(board[row][col]?.rawValue ?? "")
                                    .font(.largeTitle)
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(currentPlayer == .x ? .blue : .red)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }

            Spacer()
            Button("New Game") {
                resetGame()
                      }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            if showAlert {
                Button("Tap to show alert") {
                     showAlert = true
                 }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("New Game")) {
                            resetGame()
                        }
                    )
                }
            }
        }
        .padding()
    }

    func checkForWinner() {
        for i in 0..<3 {
            // Check rows and columns
            if board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer ||
               board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer {
                alertTitle = "\(currentPlayer.rawValue) wins!"
                alertMessage = "\(otherPlayer.rawValue) lost!"
                
                showAlert = true
                return
            }
        }

        // Check diagonals
        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer ||
           board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer {
            alertTitle = "\(currentPlayer.rawValue) wins!"
            alertMessage = "\(otherPlayer.rawValue) lost!"
            showAlert = true
            return
        }

        // Check for a tie
        if board.flatMap({ $0 }).allSatisfy({ $0 != nil }) {
            alertMessage = "It's a tie!"
            showAlert = true
        }
    }

    func switchPlayer() {
        currentPlayer = (currentPlayer == .x) ? .o : .x
    }

    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .x
        showAlert = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
