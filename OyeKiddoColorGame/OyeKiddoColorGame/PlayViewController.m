//
//  PlayViewController.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/19/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "PlayViewController.h"
#import "GameData.h"
#import "WordType.h"
#import "Words.h"
#import "Sounds.h"

@implementation PlayViewController

@synthesize playViewController, wordScene, voiceSearch;

-(void) viewDidLoad
{
  [super viewDidLoad];
  playViewController = (PlayViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"playViewController"];
  SKView *skView = (SKView *) self.view;
  skView.multipleTouchEnabled = false;
  
  wordScene = [[WordScene alloc] init: skView.bounds.size imageName:@"redback"];
  wordScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:wordScene];

  [wordScene setupHUD];
  [wordScene setupMessage];

  [[GameData sharedData] save];
  [[GameData sharedData] reset];
  trainViewState = IDLE;
  firstTime = true;
  [self generateWord];
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
- (void) generateWord
{
  trainViewState = GENERATE_WORD;
  wordIndex = [Words random];
  word = [Words sharedData].hindiNames[wordIndex];
  [wordScene addWordToScene: [Words sharedData].names[wordIndex]];
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].canYouTellMeSounds.count)].integerValue;
  if( firstTime ) {
    firstTime = false;
    [Sounds play:(AVAudioPlayer *)[Sounds sharedData].canYouTellMeSounds[ index ] delegate:self ];
  } else {
    if (voiceSearch != nil ) {
      [voiceSearch cancel];
      voiceSearch = nil;
    }
    trainViewState = START_RECORDING;
    voiceSearch = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType
                                           detection:SKShortEndOfSpeechDetection
                                            language:@"hi_IN"
                                            delegate:self];
  }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  switch( trainViewState ) {
    case GENERATE_WORD:
    case ZERO_RESULTS:
    case FAILED_RECORDING:
      [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
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
    case RECOGNIZED:
      [ wordScene removeWordFromScene ];
      [self generateWord];
      break;
    case DIDNT_RECOGNIZE:
      [ wordScene removeWordFromScene ];
      [[self navigationController] popToRootViewControllerAnimated:true];
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
  long numResults = [results.results count];
  
  Boolean found = false;
//  NSLog(@"Got Here numResults = %ld", numResults );
  if( numResults != 0 ) {
    NSMutableDictionary *dict = [GameData sharedData].dict;
    NSMutableDictionary *alternatives = dict[word];
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
      trainViewState = DIDNT_RECOGNIZE;
      voiceSearch = nil;
      [Sounds play:(AVAudioPlayer *)[Sounds sharedData].wrongWordSounds[ word ] delegate:self ];
    } else {
      trainViewState = RECOGNIZED;
      for( int i = 0; i < numResults; i++ ) {
        NSString *sentence = results.results[i];
        NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for( NSString *w in words ) {
          [alternatives setObject:w forKey:w];
        }
      }
      [ wordScene incrementScore];
      [[GameData sharedData] save];
      [wordScene setMessageText:@"Correct" color:[SKColor greenColor]];
      long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].rightWordSounds.count)].integerValue;
      [Sounds play:(AVAudioPlayer *)[Sounds sharedData].rightWordSounds[ index ] delegate:self ];
    }
  } else {
    trainViewState = ZERO_RESULTS;
    [wordScene setMessageText:@"Try Again" color:[SKColor redColor]];
    long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].tryAgainSounds.count)].integerValue;
    [Sounds play:(AVAudioPlayer *)[Sounds sharedData].tryAgainSounds[ index ] delegate:self ];
  }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
  if( voiceSearch == nil ) {
    return;
  }
  trainViewState = FAILED_RECORDING;
  [wordScene setMessageText:@"Try Again" color:[SKColor redColor]];
  long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].tryAgainSounds.count)].integerValue;
  [Sounds play:(AVAudioPlayer *)[Sounds sharedData].tryAgainSounds[ index ] delegate:self ];
}

@end
