//
//  CardsDeckView.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/08/01.
//

import SwiftUI

struct CardDeckView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var showingAddDeckView = false
  @State private var editActive = false
  @Binding var selectedCards: [Card]

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(fetchRequest: Deck.fetch()) var decks: FetchedResults<Deck>

  var body: some View {
    NavigationView {
      List {
        ForEach(0..<decks.count, id: \.self) { index in
          if !editActive {
            Button(action: {
              selectedCards = Array(decks[index].cards)
              presentationMode.wrappedValue.dismiss()
            }, label: {
              HStack {
                Text(decks[index].name)
                Spacer()
                Text("\(decks[index].cards.count) / 50")
              }
            })
          } else {
            NavigationLink(
              destination: EditCardsView(deck: decks[index]),
              label: {
                HStack {
                  Text(decks[index].name)
                  Spacer()
                  Text("\(decks[index].cards.count) / 50")
                }
              }) //: NavigationLink
              .environment(\.managedObjectContext, self.viewContext)
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
        AddCardDeckView(showingAddDeckView: $showingAddDeckView)
        .environment(\.managedObjectContext, self.viewContext)
      } //: Sheet
    } //: NavigationView
  } //: Body

  func removeDeck(at offsets: IndexSet) {
    let decks = Array(decks)
    if let index = offsets.first {
      let deck = decks[index]
      self.viewContext.delete(deck)
      try? self.viewContext.save()
    }
  }
}

//struct CardsDeckView_Previews: PreviewProvider {
//  static var previews: some View {
//    CardDeckView(selectedCards: .constant([Card.example]))
//  }
//}
