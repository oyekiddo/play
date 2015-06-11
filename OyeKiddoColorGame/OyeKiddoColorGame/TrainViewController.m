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
  
  trainViewController = (TrainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"trainViewController"];
  SKView *skView = (SKView *) self.view;
  skView.multipleTouchEnabled = false;
  
  wordScene = [[WordScene alloc] init: skView.bounds.size imageName:@"blueback"];
  wordScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:wordScene];

  [wordScene setupMessage];
  
  lessonNumber = 0;
  word = [Words sharedData].names[lessonNumber];
  trainViewState = IDLE;
  [self startLesson];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
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
  switch( trainViewState ) {
    case START_LESSON:
    case DIDNT_RECOGNIZE:
    case FAILED_RECORDING:
      if (voiceSearch) voiceSearch = nil;
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
  [wordScene setMessageText:@"Speak Now" color:[SKColor greenColor]];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
  [wordScene setMessageText:@"" color:[SKColor redColor]];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
  NSString *hindiName = [Words sharedData].hindiNames[lessonNumber];
  NSMutableDictionary *dict = [GameData sharedData].dict;
  NSMutableDictionary *wordDictionary = dict[word];
  if( wordDictionary == nil ) {
    wordDictionary = [NSMutableDictionary dictionary];
    [wordDictionary setObject:[NSNumber numberWithInt: 1] forKey:hindiName];
    [GameData sharedData].dict[word] = wordDictionary;
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
      for( NSString *w2 in wordDictionary ) {
//        NSLog([NSString stringWithFormat:@"comparing %@ with %@", w, w2]);
        if( [w compare: w2] == NSOrderedSame ) {
//          NSLog(@"found");
          found = true;
          break;
        }
      }
      if( found ) break;
    }
  }
  if( !found ) {
    for( int i = 0; i < numResults; i++ ) {
      NSString *sentence = results.results[i];
      NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      for( NSString *w in words ) {
        if( [wordDictionary objectForKey:w]) {
          NSNumber *num = [wordDictionary objectForKey:w];
          num = @(num.integerValue + 1);
          [wordDictionary setObject:num forKey:w];
//          NSLog([NSString stringWithFormat:@"incrementing key %@ to value %d", w, num.integerValue]);
        } else {
          [wordDictionary setObject:[NSNumber numberWithInt: 1] forKey:w];
//          NSLog([NSString stringWithFormat:@"adding key %@", w]);
        }
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
      word = [Words sharedData].names[lessonNumber];
      voiceSearch = nil;
      [self startLesson];
    } else {
      [[self navigationController] popToRootViewControllerAnimated:true];
    }
  }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
  trainViewState = FAILED_RECORDING;
  voiceSearch = nil;
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  [Sounds play:(AVAudioPlayer *)[Sounds sharedData].didntGetSounds[word] delegate:self ];
}

@end
