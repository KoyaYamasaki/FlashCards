//
//  Card.swift
//  Flashzilla
//
//  Created by 山崎宏哉 on 2021/07/29.
//

import Foundation

struct Card: Codable {
  let prompt: String
  let answer: String
  
  static var example: Card {
    Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
  }
}
