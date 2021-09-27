//
//  Card.swift
//  Flashcards
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
  static let saveKey = "SavedData"

  init() {
    items = []

    do {
      let fileName = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
      let data = try Data(contentsOf: fileName)
      self.items = try JSONDecoder().decode([CardDeck].self, from: data)
    } catch {
      print("Unable to load saved data.")
    }
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  func add(_ cardDeck: CardDeck) {
    items.append(cardDeck)
    save()
  }

  func loadData() {
    if let data = UserDefaults.standard.data(forKey: "CardDecks") {
      if let decoded = try? JSONDecoder().decode([CardDeck].self, from: data) {
        self.items = decoded
      } else {
        self.items = []
      }
    } else {
      self.items = []
    }
  }

  func saveData() {
    if let data = try? JSONEncoder().encode(items) {
      UserDefaults.standard.set(data, forKey: "CardDecks")
    }
  }

  func save() {
    do {
      let fileName = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
      let data = try JSONEncoder().encode(self.items)
      try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
    } catch {
      print("Unable to save data.")
    }
  }
}
