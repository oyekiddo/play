//
//  Word.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/19/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize wordType;

-(id) init:(WordType) type
{
  wordType = type;
  return self;
}

-(id) initRandom
{
  long count = [NSNumber numberWithInt:arc4random_uniform( (int) numWords )].integerValue;
  wordType = (WordType) count;
  return self;
}


-(NSString *) name
{
  NSArray *names = @[ @"Red", @"Yellow", @"Green", @"Blue", @"White", @"Black" ];
  return names[ self.wordType ];
}

-(NSString *) labeledName
{
  NSArray *names = @[ @"Red-Labeled", @"Yellow-Labeled", @"Green-Labeled", @"Blue-Labeled", @"White-Labeled", @"Black-Labeled" ];
  return names[ self.wordType ];
}

-(NSString *) hindiName
{
  NSArray *names = @[ @"लाल", @"पीला", @"हरा", @"नीला", @"सफ़ेद", @"काला" ];
  return names[ self.wordType ];
}

@end
