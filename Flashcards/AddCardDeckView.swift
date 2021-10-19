//
//  AddCardDeckView.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/08/02.
//

import SwiftUI

struct AddCardDeckView: View {
  @State private var name: String = ""
  @State private var discription: String = ""
  @Binding var showingAddDeckView: Bool

  var saveDeck: ((CardDeck) -> Void)?

  var body: some View {
    NavigationView {
      List {
        Section {
          TextField("Name", text: $name)
          TextField("Discription", text: $discription)
        }
        NavigationLink(
          destination: CreateDecksView(),
          label: {
            Text("Create Decks from text")
          })
          .environment(\.managedObjectContext, viewContext)
      } //: List
      .listStyle(GroupedListStyle())
      .navigationTitle("Add New Deck")
      .navigationBarItems(
      leading:
        Button("Back", action: {
          self.showingAddDeckView = false
        }),
      trailing:
        Button("Save", action: saveAndDismiss)
      )
    } //: NavigationView
  } //: Body

  func saveAndDismiss() {
    let cardDeck = CardDeck(id: UUID(), name: name, cards: [])
    saveDeck!(cardDeck)
    self.showingAddDeckView = false
  }
}

struct AddCardDeckView_Previews: PreviewProvider {
  static var previews: some View {
    AddCardDeckView(showingAddDeckView: .constant(true)) { newDeck in
      print(newDeck)
    }
    .previewLayout(.fixed(width: 644, height: 421))
  }
}
