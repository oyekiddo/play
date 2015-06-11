//
//  PlayViewController.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/19/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerViewController.h"
#import "TrainViewState.h"
#import "WordScene.h"

@interface PlayViewController : AudioPlayerViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate> {
  PlayViewController *playViewController;
  WordScene *wordScene;
  NSString *word;

  SKRecognizer* voiceSearch;

  TrainViewState trainViewState;
  
  NSNumber *one;
};

@property (nonatomic,retain) PlayViewController *playViewController;
@property (nonatomic,retain) WordScene *wordScene;
@property(readonly) SKRecognizer* voiceSearch;

@end
