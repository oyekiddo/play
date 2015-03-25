//
//  JungleView.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/18/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//

import SpriteKit

class JungleScene: SKScene {
  //    override func didMoveToView(view: SKView) {
  //        /* Setup your scene here */
  //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
  //        myLabel.text = "Hello, World!";
  //        myLabel.fontSize = 65;
  //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
  //
  //        self.addChild(myLabel)
  //    }
  //
  //    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
  //        /* Called when a touch begins */
  //
  //        for touch: AnyObject in touches {
  //            let location = touch.locationInNode(self)
  //
  //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
  //
  //            sprite.xScale = 0.5
  //            sprite.yScale = 0.5
  //            sprite.position = location
  //
  //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
  //
  //            sprite.runAction(SKAction.repeatActionForever(action))
  //
  //            self.addChild(sprite)
  //        }
  //    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    let background = SKSpriteNode(imageNamed: "Jungle")
    var scale = max(size.width/background.size.width, size.height/background.size.height);
    background.xScale = scale
    background.yScale = scale
    addChild(background)
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
