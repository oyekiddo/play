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
#import "WordScene.h"
#import "TrainViewState.h"

@interface TrainViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate> {
  TrainViewController *trainViewController;
  WordScene *wordScene;
  Word *word;
  int lessonNumber;
  
  AVAudioPlayer *canYouSaySounds[6];
  AVAudioPlayer *didntGetSounds[6];
  
  SKRecognizer* voiceSearch;

  TrainViewState trainViewState;
};

@property (nonatomic,retain) TrainViewController *trainViewController;
@property (nonatomic,retain) WordScene *wordScene;
@property(readwrite) int lessonNumber;
@property(readwrite) TrainViewState trainViewState;
@property(readwrite) SKRecognizer* voiceSearch;

@end
