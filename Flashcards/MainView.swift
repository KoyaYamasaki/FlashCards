//
//  MainView.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/10/23.
//

import SwiftUI

struct MainView: View {
  @State private var showContentView = false
  @State private var cards: [Card] = []

  @Environment(\.managedObjectContext) private var viewContext
  var body: some View {
    if showContentView {
      ContentView(cards: $cards, showContentView: $showContentView)
        .environment(\.managedObjectContext, viewContext)
    } else {
      CardDeckView(selectedCards: $cards, showContentView: $showContentView)
        .environment(\.managedObjectContext, viewContext)
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
