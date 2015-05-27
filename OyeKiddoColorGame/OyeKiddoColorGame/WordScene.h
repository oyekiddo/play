//
//  TrainView.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/18/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Word.h"

@interface WordScene : SKScene {
  CGSize viewSize;
  SKSpriteNode *background;
  SKSpriteNode *wordSprite;
}

-(id) init: (CGSize) size imageName:(NSString *) imageName;
-(void) addWordToScene:(NSString *) spriteName;
-(void) removeWordFromScene;
-(void) setupHUD;
-(void) setupMessage;
-(void) setMessageText:(NSString *) message color:(SKColor*) fontColor;
-(void) incrementScore;

@end
