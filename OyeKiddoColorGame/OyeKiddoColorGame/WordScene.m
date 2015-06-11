//
//  TrainView.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/18/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "WordScene.h"
#import "GameData.h"

@implementation WordScene

SKLabelNode* _score;
SKLabelNode* _highScore;
SKLabelNode* _speak;

-(id) init: (CGSize) size imageName:(NSString *) imageName
{
  self = [super initWithSize:size];
  viewSize = size;
  
  self.anchorPoint = CGPointMake( 0.5, 0.5);
  
  background = [SKSpriteNode spriteNodeWithImageNamed:imageName];
  [self addChild:background];
  return self;
}

-(void) addWordToScene:(NSString *) spriteName
{
  wordSprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName ];
  wordSprite.alpha = 0.0;
  CGSize wsize = wordSprite.size;
  double scale = MIN( viewSize.width/wsize.width, viewSize.height/wsize.height );
  wordSprite.xScale = scale * 0.5;
  wordSprite.yScale = scale * 0.5;
  [self addChild:wordSprite];
  
  [wordSprite runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration: 0.25 withRange: 0.5 ],
                                             [SKAction group: @[
                                                                [SKAction fadeInWithDuration:0.3],
                                                                [SKAction scaleTo: scale duration:0.25 ]
                                                                ]]]]];
}

-(void) removeWordFromScene
{
  [wordSprite removeFromParent];
}

-(void) setupHUD
{
  _score = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
  _score.fontSize = 24.0;
  _score.position = CGPointMake((-viewSize.width/2) + 40, (-viewSize.width/2) - 12);
  _score.fontColor = [SKColor greenColor];
  _score.text = @"Score: 0";
  [self addChild:_score];
  
  _highScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
  _highScore.fontSize = 24.0;
  _highScore.position = CGPointMake(20,  (-viewSize.width/2) - 12);
  _highScore.fontColor = [SKColor redColor];
  _highScore.text = [NSString stringWithFormat:@"High Score: %li", [GameData sharedData].highScore];
  [self addChild:_highScore];
}

-(void) incrementScore
{
  [GameData sharedData].score = [GameData sharedData].score + 1;
  _score.text = [NSString stringWithFormat:@"Score: %li", [GameData sharedData].score];
  [GameData sharedData].highScore = MAX( [GameData sharedData].score, [GameData sharedData].highScore );
  _highScore.text = [NSString stringWithFormat:@"High Score: %li", [GameData sharedData].highScore];
}

-(void) setupMessage
{
  _speak = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
  _speak.fontSize = 48.0;
  _speak.position = CGPointMake( 0,  (viewSize.width/2) + 12);
  _speak.fontColor = [SKColor redColor];
  [self addChild:_speak];
}

-(void) setMessageText:(NSString *) message color:(SKColor*) fontColor
{
  _speak.text = message;
  _speak.fontColor = fontColor;
}

@end
