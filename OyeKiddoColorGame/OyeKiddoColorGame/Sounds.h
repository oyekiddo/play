//
//  SoundManager.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 6/10/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerViewController.h"

@interface Sounds : NSObject

@property NSMutableDictionary *canYouSaySounds;
@property NSMutableDictionary *didntGetSounds;
@property NSMutableDictionary *wrongWordSounds;
@property NSMutableArray *canYouTellMeSounds;
@property NSMutableArray *rightWordSounds;
@property AVAudioPlayer *playingSound;

+(instancetype)sharedData;
+(void) play: (AVAudioPlayer *) sound delegate:(AudioPlayerViewController*)delegate;
+(void) stop;

@end
