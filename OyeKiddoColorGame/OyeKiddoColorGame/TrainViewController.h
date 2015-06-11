//
//  TrainViewController.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/18/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerViewController.h"
#import "WordScene.h"
#import "TrainViewState.h"

@interface TrainViewController : AudioPlayerViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate> {
  TrainViewController *trainViewController;
  WordScene *wordScene;
  int lessonNumber;
  NSString *word;
  
  SKRecognizer* voiceSearch;

  TrainViewState trainViewState;
};

@property (nonatomic,retain) TrainViewController *trainViewController;
@property (nonatomic,retain) WordScene *wordScene;
@property(readwrite) int lessonNumber;
@property(readwrite) TrainViewState trainViewState;
@property(readwrite) SKRecognizer* voiceSearch;

@end
