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
  @Binding var showContentView: Bool

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
                Text("\(decks[index].cards.count) Sets")
              }
            })
          } else {
            NavigationLink(
              destination: EditCardsView(deck: decks[index]),
              label: {
                HStack {
                  Text(decks[index].name)
                  Spacer()
                  Text("\(decks[index].cards.count) Sets")
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
//            editActive.toggle()
            showContentView = true
          },
        trailing:
          Button("Add New Deck") {
            showingAddDeckView = true
          }
      )
    } //: NavigationView
    CreateDeckAlert(isShowingAlert: $showingAddDeckView)
      .environment(\.managedObjectContext, self.viewContext)
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

struct CardsDeckView_Previews: PreviewProvider {
  static var previews: some View {
    let cards = [Card(context: PersistenceController.preview.container.viewContext)]
    CardDeckView(selectedCards: .constant(cards), showContentView: .constant(false))
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      .previewLayout(.fixed(width: 644, height: 421))
  }
}
