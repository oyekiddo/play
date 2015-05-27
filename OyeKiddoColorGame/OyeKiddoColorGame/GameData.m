//
//  GameData.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/25/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "WordType.h"
#import "GameData.h"

@implementation GameData

+ (instancetype)sharedData
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once( &onceToken, ^{ sharedInstance = [[self alloc] init]; } );
  
  return sharedInstance;
}

-(id) init
{
  int capacity = (int) numWords;
  self.dict = [[NSMutableArray alloc] initWithCapacity:(int) capacity];
  self.highScore = 0;
  return self;
}

-(void)reset
{
  self.score = 0;
}

@end
