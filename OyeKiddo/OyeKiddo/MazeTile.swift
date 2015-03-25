//
//  MazeTile.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/15/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//

import SpriteKit

enum MazeTileType: Int, Printable {
  case Unknown = 0, Black, White, Red, Green, Blue, Yellow
  
  var spriteName: String {
    let spriteNames = [
      "Black",
      "White",
      "Red",
      "Green",
      "Blue",
      "Yellow"]
    
    return spriteNames[rawValue - 1]
  }
  
  var highlightedSpriteName: String {
    return spriteName + "-Highlighted"
  }
  
  static func random() -> MazeTileType {
    return MazeTileType(rawValue: Int(arc4random_uniform(6)) + 1)!
  }
  
  var description: String {
    return spriteName
  }
}

class MazeTile: Printable, Hashable {
  var column: Int
  var row: Int
  let mazeTileType: MazeTileType
  var sprite: SKSpriteNode?
  
  init(column: Int, row: Int, mazeTileType: MazeTileType) {
    self.column = column
    self.row = row
    self.mazeTileType = mazeTileType
  }
  
  var description: String {
    return "type:\(mazeTileType) square:(\(column),\(row))"
  }
  
  var hashValue: Int {
    return row*10 + column
  }
}

func ==(lhs: MazeTile, rhs: MazeTile) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row
}
