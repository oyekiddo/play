//
//  GameData.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/25/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

@property (assign, nonatomic) long score;

// persistant data
@property (assign, nonatomic) long highScore;
@property (retain, nonatomic) NSMutableArray *dict;

+(instancetype)sharedData;
-(void)reset;

@end
