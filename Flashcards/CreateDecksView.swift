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
  @State private var deckName = ""
  @State private var shapeText = false
  @State private var registerDeck = false

  @State private var prompt: [String] = []
  @State private var answer: [String] = []

  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var viewContext

  var body: some View {
    VStack {
      if shapeText {
        VStack(spacing: 10) {
          Button("Register Deck") {
            registerDeck = true
          }
          List {
            ForEach(0..<prompt.count) { index in
              HStack() {
                Text("prompt : " + prompt[index])
                  .frame(width: 300, alignment: .leading)
                Text("answer : " + answer[index])
                  .frame(width: 300, alignment: .leading)
              }
            }
          }
        }
        .padding()
      } else {
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
        .padding()
      }
    }
    .navigationTitle("Import Text")
    .navigationBarItems(
      trailing:
        Button("Create Deck from text") {
          UIApplication.shared.endEditing()
          if !text.isEmpty {
            getPromptAndAnswer()
          }
        }
        .disabled(shapeText)
    )
    .alert(isPresented: $registerDeck) {
      Alert(title: Text("Create Decks"),
            primaryButton: .default(Text("Create"), action: {
              saveToCoreData()
              registerDeck = false
              presentationMode.wrappedValue.dismiss()
            }),
            secondaryButton: .cancel(Text("Cancel"), action: {
              registerDeck = false
            })
      )
    } //: End of Alert
  } //: End of VStack

  func getPromptAndAnswer() {
    promptAndAnswers = text.components(separatedBy: "\n")
    for elem in promptAndAnswers {
      let singlePromptAndAnswer = elem.components(separatedBy: ":")
      prompt.append(singlePromptAndAnswer[0])
      answer.append(singlePromptAndAnswer[1])
    }
    shapeText = true
  }

  func saveToCoreData() {
    let coreDataDeck = Deck(uuid: UUID(), context: self.viewContext)
    coreDataDeck.name = deckName
    var coreDataCards: Set<Card> = []

    for i in 0..<prompt.count {
      let card = Card(uuid: UUID(), context: self.viewContext)
      card.prompt = prompt[i]
      card.answer = answer[i]
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
