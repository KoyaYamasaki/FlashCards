//
//  CardsDeckView.swift
//  Flashzilla
//
//  Created by 山崎宏哉 on 2021/08/01.
//

import SwiftUI

struct CardDeckView: View {
  @ObservedObject var cardDecks = CardDecks()
  @State private var showingAddDeckView = false

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<cardDecks.items.count, id: \.self) { index in
          NavigationLink(
            destination: EditCardsView(deck: $cardDecks.items[index]) { saveDeck in
              cardDecks.items[index] = saveDeck
              cardDecks.saveData()
            },
            label: {
              HStack {
                Text(cardDecks.items[index].name)
                Spacer()
                Text("\(cardDecks.items[index].cards.count) / 50")
              }
            }) //: NavigationLink
        } //: ForEach
        .onDelete(perform: removeDeck)
      } //: List
      .navigationTitle("Card Decks")
      .navigationBarItems(
        trailing:
          Button("Add Deck") {
            showingAddDeckView = true
          }
      )
      .sheet(isPresented: $showingAddDeckView) {
        AddCardDeckView(showingAddDeckView: $showingAddDeckView) { newDeck in
          cardDecks.items.append(newDeck)
          cardDecks.saveData()
        }
      } //: Sheet
    } //: NavigationView
  } //: Body

  func removeDeck(at offsets: IndexSet) {
    cardDecks.items.remove(atOffsets: offsets)
    cardDecks.saveData()
  }
}

struct CardsDeckView_Previews: PreviewProvider {
  static var previews: some View {
    CardDeckView()
  }
}
