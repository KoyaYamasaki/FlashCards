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

  var saveDeck: ((Deck) -> Void)?

  @Environment(\.managedObjectContext) private var viewContext

  var body: some View {
    NavigationView {
      List {
        Section {
          TextField("Name", text: $name)
          TextField("Discription", text: $discription)
        }
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
    let coreDataDeck = Deck(uuid: UUID(), context: self.viewContext)
    coreDataDeck.name = name
    coreDataDeck.cards = []
    try? viewContext.save()

    self.showingAddDeckView = false
  }
}

struct AddCardDeckView_Previews: PreviewProvider {
  static var previews: some View {
    AddCardDeckView(showingAddDeckView: .constant(true)) { newDeck in
      print(newDeck)
    }
  }
}
