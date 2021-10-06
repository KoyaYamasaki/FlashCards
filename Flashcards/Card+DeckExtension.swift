//
//  CardExtension.swift
//  Flashcards
//
//  Created by 山崎宏哉 on 2021/09/28.
//

import Foundation
import CoreData

extension Card {

  var uuid: UUID {
    get { uuid_ ?? UUID() }
    set { uuid_ = newValue }
  }

  var prompt: String {
    get { prompt_ ?? "" }
    set { prompt_ = newValue }
  }

  var answer: String {
    get { answer_ ?? "" }
    set { answer_ = newValue }
  }
}

extension Card: Comparable {
  public static func < (lhs: Card, rhs: Card) -> Bool {
    lhs.prompt < rhs.prompt
  }
}

extension Deck {

  var uuid: UUID {
    get { uuid_ ?? UUID() }
    set { uuid_ = newValue }
  }

  var name: String {
    get { name_ ?? "" }
    set { name_ = newValue }
  }

  var cards: Set<Card> {
    get { cards_ as? Set<Card> ?? [] }
    set { cards_ = newValue as NSSet }
  }
}
