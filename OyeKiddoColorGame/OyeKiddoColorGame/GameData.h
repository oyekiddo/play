//
//  GameData.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/25/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding, NSURLConnectionDataDelegate>

@property (assign, nonatomic) long score;
@property (retain, nonatomic) NSMutableDictionary *receivedData;
@property (assign, nonatomic) NSTimer *timer;

// persistant data
@property (assign, nonatomic) long highScore;
@property (retain, nonatomic) NSMutableDictionary *dict;
@property (assign, nonatomic) BOOL dirty;

+(instancetype)sharedData;
-(void)reset;
-(void)save;
-(void) requestDataFromServer;
-(void) sendDataToServer;
-(void) sendDataToServerIfDirty;

@end
