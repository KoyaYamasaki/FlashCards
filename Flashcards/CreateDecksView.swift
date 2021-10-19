//
//  CreateDecks.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/10/08.
//

import SwiftUI

struct CreateDecksView: View {
  @State private var text = ""
  @State private var promptAndAnswers: [String] = []
  @State private var inputText = false
  @State private var deckName = ""
  
  @Environment(\.managedObjectContext) private var viewContext
  var body: some View {
    VStack {
      VStack {
        TextField("Deck Name Here", text: $deckName)
        TextEditor(text: $text)
          .keyboardType(.alphabet)
          .font(.subheadline)
          .padding(.horizontal)
          .font(Font.system(size: 38.00))
          .frame(minWidth: 10, maxWidth: .infinity, minHeight: 10, maxHeight: 300, alignment: .topLeading)
          .border(Color.black)
          .clipped()
      }
    }
    .navigationTitle("Import Text")
    .navigationBarItems(
      trailing:
        Button("Create Deck from text") {
          UIApplication.shared.endEditing()
          inputText = true
        }
    )
    .alert(isPresented: $inputText) {
      Alert(title: Text("Create Decks"),
            primaryButton: .default(Text("Create"), action: {
              saveToCoreData()
              inputText = false
            }),
            secondaryButton: .cancel(Text("Cancel"), action: {
              inputText = false
            })
      )
    } //: End of Alert
  } //: End of VStack
  
  func saveToCoreData() {
    let coreDataDeck = Deck(uuid: UUID(), context: self.viewContext)
    coreDataDeck.name = deckName
    var coreDataCards: Set<Card> = []
    
    promptAndAnswers = text.components(separatedBy: "\n")
    for elem in promptAndAnswers {
      let singlePromptAndAnswer = elem.components(separatedBy: ":")
      
      let card = Card(uuid: UUID(), context: self.viewContext)
      card.prompt = singlePromptAndAnswer[0]
      card.answer = singlePromptAndAnswer[1]
      
      coreDataCards.insert(card)
    }
    
    coreDataDeck.cards = coreDataCards
    try? viewContext.save()
  }
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct CreateDecksView_Previews: PreviewProvider {
  static var previews: some View {
    CreateDecksView()
      .previewLayout(.fixed(width: 644, height: 421))
  }
}
