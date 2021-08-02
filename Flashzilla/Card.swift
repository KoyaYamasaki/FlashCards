//
//  Card.swift
//  Flashzilla
//
//  Created by 山崎宏哉 on 2021/07/29.
//

import Foundation

struct Card: Codable {
  let id: UUID
  let prompt: String
  let answer: String
  
  static var example: Card {
    Card(id: UUID(), prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
  }
}

struct CardDeck: Codable, Identifiable {
  let id: UUID
  let name: String
  var cards: [Card]

  static var example: CardDeck {
    CardDeck(id: UUID(), name: "Example1", cards: [Card.example])
  }
}

class CardDecks: ObservableObject {
  @Published var items: [CardDeck]

  init() {
    self.items = []
//    items.append(CardDeck.example)

    if let data = UserDefaults.standard.data(forKey: "CardDecks") {
      if let decoded = try? JSONDecoder().decode([CardDeck].self, from: data) {
        self.items = decoded
      }
    }
  }

  func saveData() {
    if let data = try? JSONEncoder().encode(items) {
      UserDefaults.standard.set(data, forKey: "CardDecks")
    }
  }
}
