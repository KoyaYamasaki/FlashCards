//
//  FlashcardsApp.swift
//  FlashcardsApp
//
//  Created by 山崎宏哉 on 2021/07/27.
//

import SwiftUI

@main
struct FlashcardsApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      MainView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
