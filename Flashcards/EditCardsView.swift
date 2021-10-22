//
//  EditCardView.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/07/29.
//

import SwiftUI

struct EditCardsView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var newPrompt = ""
  @State private var newAnswer = ""
  @ObservedObject var deck: Deck
  @Environment(\.managedObjectContext) var viewContext

  var body: some View {
//    NavigationView {
      List {
        Section(header: Text("Add new card")) {
          TextField("Prompt", text: $newPrompt)
          TextField("Answer", text: $newAnswer)
          Button("Add card", action: addCard)
        }
        
        Section(header: Text("Added")) {
          ForEach(deck.cards.sorted()) { card in
            VStack(alignment: .leading) {
              Text(card.prompt)
                .font(.headline)
              Text(card.answer)
                .foregroundColor(.secondary)
            }
          }
          .onDelete(perform: removeCards)
        }
      }
      .navigationBarTitle(deck.name)
      .navigationBarItems(trailing: Button("Save", action: saveAndDismiss))
      .listStyle(GroupedListStyle())
//    }
//    .navigationViewStyle(StackNavigationViewStyle())
  }

  func saveAndDismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
  func addCard() {
    let card = Card(uuid: UUID(), context: self.viewContext)
    card.prompt = newPrompt
    card.answer = newAnswer
    deck.cards.insert(card)
    try? self.viewContext.save()

    newPrompt = ""
    newAnswer = ""
  }

  func removeCards(at offsets: IndexSet) {
    let cards = Array(deck.cards)
    if let index = offsets.first {
      let card = cards[index]
      self.viewContext.delete(card)
      try? self.viewContext.save()
    }
  }
}

struct EditCardsView_Previews: PreviewProvider {
  static var previews: some View {
    EditCardsView(deck: Deck(context: PersistenceController.shared.container.viewContext))
  }
}
