//
//  SoundManager.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 6/10/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "Sounds.h"
#import "WordType.h"
#import "Words.h"

@implementation Sounds

- (instancetype)init
{
  NSArray *canYouSayFilenames = @[ @"laal", @"peela2", @"hara", @"neela", @"safed", @"kala2"];
  NSArray *didntGetFilenames = @[ @"didntgetlaal", @"didntgetpeela", @"didntgethara", @"didntgetneela", @"didntgetsafed", @"didntgetkala"];
  NSArray *wrongWordFilenames = @[ @"wronglaal", @"wrongpeela", @"wronghara", @"wrongneela", @"wrongsafed", @"wrongkaala"];
  
  self.canYouSaySounds = [[NSMutableDictionary alloc] init];
  self.didntGetSounds = [[NSMutableDictionary alloc] init];
  self.wrongWordSounds = [[NSMutableDictionary alloc] init];
  for (int i = 0; i < canYouSayFilenames.count; i++ ) {
    NSString *name = [Words sharedData].hindiNames[i];
    self.canYouSaySounds[name] = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:canYouSayFilenames[i] ofType: @"wav" ]]
                                  error:nil
                                  ];
    self.didntGetSounds[name] = [[AVAudioPlayer alloc]
                                 initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:didntGetFilenames[i] ofType: @"wav" ]]
                                 error:nil
                                 ];
    self.wrongWordSounds[name] = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:wrongWordFilenames[i] ofType: @"wav" ]]
                                  error:nil
                                  ];
  }

  NSArray *canYouTellMeFilenames = @[ @"canYouTellMe", @"canYouTellMe2"];
  self.canYouTellMeSounds = [[NSMutableArray alloc] initWithCapacity:canYouTellMeFilenames.count];
  for (int i = 0; i < canYouTellMeFilenames.count; i++ ) {
    self.canYouTellMeSounds[i] = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:canYouTellMeFilenames[i] ofType: @"wav" ]]
                                  error:nil
                                  ];
  }

  NSArray *rightWordFilenames = @[ @"right", @"right2", @"right3", @"right4"];
  self.rightWordSounds = [[NSMutableArray alloc] initWithCapacity:rightWordFilenames.count];
  for (int i = 0; i < rightWordFilenames.count; i++ ) {
    self.rightWordSounds[i] = [[AVAudioPlayer alloc]
                               initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:rightWordFilenames[i] ofType: @"wav" ]]
                               error:nil
                               ];
  }

  return self;
}

+ (instancetype)sharedData
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once( &onceToken, ^{ sharedInstance = [[self alloc] init]; } );
  
  return sharedInstance;
}

+(void) play: (AVAudioPlayer *) sound delegate:(AudioPlayerViewController*)delegate
{
  sound.delegate = delegate;
  AVAudioPlayer* playingSound = [Sounds sharedData].playingSound;
  if( playingSound != nil ) {
    [playingSound stop];
    [Sounds sharedData].playingSound = nil;
  }
  [Sounds sharedData].playingSound = sound;
  [sound play];
}

+(void) stop
{
  AVAudioPlayer* playingSound = [Sounds sharedData].playingSound;
  [playingSound stop];
  playingSound.delegate = nil;
  [Sounds sharedData].playingSound = nil;
}
@end
