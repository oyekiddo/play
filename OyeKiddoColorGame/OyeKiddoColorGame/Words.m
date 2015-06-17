//
//  Words.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 6/10/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "Words.h"

@implementation Words

- (instancetype)init
{
  self.names = @[ @"Red", @"Yellow", @"Green", @"Blue", @"White", @"Black" ];
  self.labeledNames = @[ @"Red-Labeled", @"Yellow-Labeled", @"Green-Labeled", @"Blue-Labeled", @"White-Labeled", @"Black-Labeled" ];
  self.hindiNames = @[ @"लाल", @"पीला", @"हरा", @"नीला", @"सफ़ेद", @"काला" ];
  return self;
}

+ (instancetype)sharedData
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once( &onceToken, ^{ sharedInstance = [[self alloc] init]; } );
  
  return sharedInstance;
}

+ (int) random
{
  return arc4random_uniform((int) [Words sharedData].hindiNames.count);
}
@end
