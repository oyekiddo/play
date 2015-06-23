//
//  TrainViewController.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/18/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "TrainViewController.h"
#import "GameData.h"
#import "WordType.h"
#import "Words.h"
#import "Sounds.h"

@implementation TrainViewController

@synthesize trainViewController, wordScene, lessonNumber, voiceSearch, trainViewState;

-(void) viewDidLoad
{
  [super viewDidLoad];
  
  [UIApplication sharedApplication];
  trainViewController = (TrainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"trainViewController"];
  SKView *skView = (SKView *) self.view;
  skView.multipleTouchEnabled = false;
  
  wordScene = [[WordScene alloc] init: skView.bounds.size imageName:@"blueback"];
  wordScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:wordScene];

  [wordScene setupMessage];
  
  lessonNumber = 0;
  word = [Words sharedData].hindiNames[lessonNumber];
  trainViewState = IDLE;
  [self startLesson];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [Sounds stop];
  if (voiceSearch != nil ) {
    [voiceSearch cancel];
    voiceSearch = nil;
  }
}

- (void) startLesson
{
  trainViewState = START_LESSON;
  [wordScene addWordToScene: [Words sharedData].labeledNames[lessonNumber]];
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  [Sounds play:(AVAudioPlayer *)[Sounds sharedData].canYouSaySounds[word] delegate:self ];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  switch( trainViewState ) {
    case START_LESSON:
    case DIDNT_RECOGNIZE:
    case FAILED_RECORDING:
      if (voiceSearch != nil ) {
        [voiceSearch cancel];
        voiceSearch = nil;
      }
      trainViewState = START_RECORDING;
      voiceSearch = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType
                                             detection:SKShortEndOfSpeechDetection
                                              language:@"hi_IN"
                                              delegate:self];
      break;
    default:
      break;
  }
}

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
  [wordScene setMessageText:@"What color is this?" color:[SKColor blackColor]];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
  [wordScene setMessageText:@"" color:[SKColor redColor]];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
  NSString *hindiName = [Words sharedData].hindiNames[lessonNumber];
  NSMutableDictionary *dict = [GameData sharedData].dict;
  NSMutableDictionary *alternatives = dict[word];
  if( alternatives == nil ) {
    alternatives = [[NSMutableDictionary alloc] init];
    [alternatives setObject:hindiName forKey:hindiName];
    [GameData sharedData].dict[word] = alternatives;
//    NSLog([NSString stringWithFormat:@"adding key %@", hindiName]);
  }
  long numResults = [results.results count];
  
  Boolean found = false;
//  NSLog(@"Got Here numResults = %ld", numResults );
  for( int i = 0; i < numResults; i++ ) {
    NSString *sentence = results.results[i];
    NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for( NSString *w in words ) {
      //      NSLog([NSString stringWithFormat:@"TESTING %@", w]);
      if( [alternatives objectForKey:w] ) {
        found = true;
        break;
      }
    }
    if( found ) break;
  }
  if( !found ) {
    for( int i = 0; i < numResults; i++ ) {
      NSString *sentence = results.results[i];
      NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      for( NSString *w in words ) {
        [alternatives setObject:w forKey:w];
      }
    }
    [[GameData sharedData] save];
    trainViewState = DIDNT_RECOGNIZE;
    voiceSearch = nil;
    [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
    [Sounds play:(AVAudioPlayer *)[Sounds sharedData].didntGetSounds[word] delegate:self ];
  } else {
    trainViewState = RECOGNIZED;
    WordType count = numWords;
    if( lessonNumber < (count - 1) ) {
      [wordScene removeWordFromScene];
      lessonNumber++;
      word = [Words sharedData].hindiNames[lessonNumber];
      voiceSearch = nil;
      [self startLesson];
    } else {
      [[self navigationController] popToRootViewControllerAnimated:true];
    }
  }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
  if( voiceSearch == nil ) {
    return;
  }
  trainViewState = FAILED_RECORDING;
  voiceSearch = nil;
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  [Sounds play:(AVAudioPlayer *)[Sounds sharedData].didntGetSounds[word] delegate:self ];
}

@end
