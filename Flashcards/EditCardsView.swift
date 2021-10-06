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
  var deck: Deck
  @Environment(\.managedObjectContext) var viewContext

  var saveDeck: ((Deck) -> Void)?
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
    saveDeck!(deck)
    presentationMode.wrappedValue.dismiss()
  }
  
  func addCard() {
    let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
    let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
    guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
    
//    let card = Card(id: UUID(), prompt: trimmedPrompt, answer: trimmedAnswer)
    let card = Card(context: self.viewContext)
    card.prompt = newPrompt
    card.answer = newAnswer
//    let coreDataDeck = Deck_(context: self.viewContext)
//    coreDataDeck.uuid = UUID()
//    coreDataDeck.name = name
//    coreDataDeck.cards = []
//    try? viewContext.save()
    deck.cards.insert(card)
    try? self.viewContext.save()
    print(deck.cards.count)
  }

  func removeCards(at offsets: IndexSet) {
//    deck.cards.remove(atOffsets: offsets)
  }
}

//struct EditCardsView_Previews: PreviewProvider {
//  static var previews: some View {
//    EditCardsView(deck: .constant(CardDeck.example)) { savedeck in
//      print(savedeck)
//    }
//  }
//}
