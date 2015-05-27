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
#import "TrainViewState.h"
#import "WordScene.h"
#import "GameData.h"

@interface PlayViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate> {
  PlayViewController *playViewController;
  WordScene *wordScene;
  Word *word;

  AVAudioPlayer *canYouTellMeSounds[2];
  AVAudioPlayer *wrongWordSounds[6];
  AVAudioPlayer *rightWordSounds[4];

  SKRecognizer* voiceSearch;

  TrainViewState trainViewState;
};

@property (nonatomic,retain) PlayViewController *playViewController;
@property (nonatomic,retain) WordScene *wordScene;
@property(readonly) SKRecognizer* voiceSearch;

@end
