//
//  CardsDeckView.swift
//  Flashzilla
//
//  Created by 山崎宏哉 on 2021/08/01.
//

import SwiftUI

struct CardDeckView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var cardDecks = CardDecks()
  @State private var showingAddDeckView = false
  @State private var editActive = false
  @Binding var selectedCards: [Card]

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<cardDecks.items.count, id: \.self) { index in
          if !editActive {
            Button(action: {
              selectedCards = cardDecks.items[index].cards
              presentationMode.wrappedValue.dismiss()
            }, label: {
              HStack {
                Text(cardDecks.items[index].name)
                Spacer()
                Text("\(cardDecks.items[index].cards.count) / 50")
              }
            })
          } else {
            NavigationLink(
              destination: EditCardsView(deck: $cardDecks.items[index]) { saveDeck in
                cardDecks.items[index] = saveDeck
                cardDecks.save()
              },
              label: {
                HStack {
                  Text(cardDecks.items[index].name)
                  Spacer()
                  Text("\(cardDecks.items[index].cards.count) / 50")
                }
              }) //: NavigationLink
          }
        } //: ForEach
        .onDelete(perform: removeDeck)
      } //: List
      .navigationTitle("Card Decks")
      .navigationBarItems(
        leading:
          Button(editActive ? "Done": "Edit") {
            editActive.toggle()
          },
        trailing:
          Button("Add Deck") {
            showingAddDeckView = true
          }
      )
      .sheet(isPresented: $showingAddDeckView) {
        AddCardDeckView(showingAddDeckView: $showingAddDeckView) { newDeck in
          cardDecks.add(newDeck)
        }
      } //: Sheet
    } //: NavigationView
  } //: Body

  func removeDeck(at offsets: IndexSet) {
    cardDecks.items.remove(atOffsets: offsets)
    cardDecks.save()
  }
}

struct CardsDeckView_Previews: PreviewProvider {
  static var previews: some View {
    CardDeckView(selectedCards: .constant([Card.example]))
  }
}
