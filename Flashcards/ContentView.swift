//
//  ContentView.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/07/27.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
  @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
  @Environment(\.accessibilityEnabled) var accessibilityEnabled
  
  @State private var cards: [Card] = []
  @State private var cardsForRestart: [Card] = []
  @State private var numberOfCards = 0
  @State private var isActive = true
  
  @State private var showingEditScreen = true
  @State private var correctAnswerCount: Int = 0
  let backgroundImage = "background\(Int.random(in: 1...10))"

  var body: some View {
    ZStack {
      Image(decorative: backgroundImage)
        .resizable()
        .scaledToFill()
        .edgesIgnoringSafeArea(.all)
      VStack {
        Text(showCardRemainings)
          .font(.largeTitle)
          .foregroundColor(.white)
          .padding(.horizontal, 20)
          .padding(.vertical, 5)
          .background(
            Capsule()
              .fill(Color.black)
              .opacity(0.75)
          )
        
        ZStack {
          ForEach(0..<cards.count, id: \.self) { index in
            CardView(card: self.cards[index]) { answerCorrect in
              if answerCorrect {
                correctAnswerCount += 1
              }
              withAnimation {
                self.removeCard(at: index)
              }
            }
            .stacked(at: index, in: self.cards.count)
            .allowsHitTesting(index == self.cards.count - 1)
            .accessibility(hidden: index < self.cards.count - 1)
          }
        }
        .allowsHitTesting(cards.count > 0)
        
        if cards.isEmpty {
          Button("Restart?", action: {
            cards = cardsForRestart
            resetCards()
          })
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
        }
      } //: VStack
      
      VStack {
        HStack {
          Spacer()
          
          Button(action: {
            self.showingEditScreen = true
          }) {
            Image(systemName: "pencil.circle")
              .padding()
              .background(Color.black.opacity(0.7))
              .clipShape(Circle())
          }
          .padding(.trailing, 50)
        }
        
        Spacer()
      }
      .foregroundColor(.white)
      .font(.largeTitle)
      .padding()
      
      if differentiateWithoutColor || accessibilityEnabled {
        AccessibilityView() {
          self.removeCard(at: self.cards.count - 1)
        }
      } //: differntiateWithoutColor
    } //: ZStack
    .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
      CardDeckView(selectedCards: $cards)
    }
    .onAppear(perform: resetCards)
  }

  var showCardRemainings: String {
    if cards.count != 0 {
      return "\(cards.count) / \(numberOfCards)"
    } else {
      return "Correct \(correctAnswerCount) out of \(numberOfCards)"
    }
  }

  func resetCards() {
    correctAnswerCount = 0
    numberOfCards = cards.count
    cardsForRestart = cards
    isActive = true
  }
  
  func removeCard(at index: Int) {
    guard index >= 0 else { return }
    
    cards.remove(at: index)
    if cards.isEmpty {
      isActive = false
    }
  }
}

extension View {
  func stacked(at position: Int, in total: Int) -> some View {
    let offset = CGFloat(total - position)
    return self.offset(CGSize(width: 0, height: offset * 10))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewLayout(.fixed(width: 1000, height: 500))
  }
}

struct AccessibilityView: View {
  var removeCard: () -> Void

  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Button(action: {
          withAnimation {
            removeCard()
          }
        }) {
          Image(systemName: "xmark.circle")
            .padding()
            .background(Color.black.opacity(0.7))
            .clipShape(Circle())
        }
        .accessibility(label: Text("Wrong"))
        .accessibility(hint: Text("Mark your answer as being incorrect."))
        Spacer()
        
        Button(action: {
          withAnimation {
            removeCard()
          }
        }) {
          Image(systemName: "checkmark.circle")
            .padding()
            .background(Color.black.opacity(0.7))
            .clipShape(Circle())
        }
        .accessibility(label: Text("Correct"))
        .accessibility(hint: Text("Mark your answer as being correct."))
      }
      .foregroundColor(.white)
      .font(.largeTitle)
      .padding()
    }
  }
}