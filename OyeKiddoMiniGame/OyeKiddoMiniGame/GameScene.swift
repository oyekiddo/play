//
//  GameScene.swift
//  OyeKiddoMiniGame
//
//  Created by Gregory Omi on 5/7/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    let background = SKSpriteNode(imageNamed: "Felt")
    var scale = max(size.width/background.size.width, size.height/background.size.height);
    background.xScale = scale
    background.yScale = scale
    addChild(background)
    
    SKLabelNode(fontNamed: "GillSans-BoldItalic")
  }

  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
