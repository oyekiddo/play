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

- (void)viewDidDisappear:(BOOL)animated
{
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
    if (voiceSearch) voiceSearch = nil;
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
      if (voiceSearch) voiceSearch = nil;
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
    case FAILED_RECORDING:
      [ wordScene removeWordFromScene ];
      [[self navigationController] popToRootViewControllerAnimated:true];
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
  long numResults = [results.results count];
  
  Boolean found = false;
//  NSLog(@"Got Here numResults = %ld", numResults );
  if( numResults != 0 ) {
    NSMutableDictionary *dict = [GameData sharedData].dict;
    NSString *alternatives = dict[word];
    NSMutableArray *alternativesArray = [[NSMutableArray alloc] initWithArray:[alternatives componentsSeparatedByString:@","]];
    for( int i = 0; i < numResults; i++ ) {
      NSString *sentence = results.results[i];
      NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      for( NSString *w in words ) {
        //      NSLog([NSString stringWithFormat:@"TESTING %@", w]);
        for( NSString *w2 in alternativesArray ) {
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
      trainViewState = DIDNT_RECOGNIZE;
      voiceSearch = nil;
      [Sounds play:(AVAudioPlayer *)[Sounds sharedData].wrongWordSounds[ word ] delegate:self ];
    } else {
      trainViewState = RECOGNIZED;
      for( int i = 0; i < numResults; i++ ) {
        NSString *sentence = results.results[i];
        NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for( NSString *w in words ) {
          Boolean found2 = false;
          for (NSString *w2 in alternativesArray) {
            if( [w compare: w2] == NSOrderedSame ) {
              found2 = true;
              break;
            }
          }
          if ( !found2 ) {
            [alternativesArray addObject:w];
            //          NSLog([NSString stringWithFormat:@"adding key %@", w]);
          }
        }
      }
      [ wordScene incrementScore];
      dict[word] = [alternativesArray componentsJoinedByString:@","];
      [[GameData sharedData] save];
      long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].rightWordSounds.count)].integerValue;
      [Sounds play:(AVAudioPlayer *)[Sounds sharedData].rightWordSounds[ index ] delegate:self ];
    }
  } else {
    trainViewState = ZERO_RESULTS;
    long index = [NSNumber numberWithInt:arc4random_uniform((int) [Sounds sharedData].tryAgainSounds.count)].integerValue;
    [Sounds play:(AVAudioPlayer *)[Sounds sharedData].tryAgainSounds[ index ] delegate:self ];
  }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
  trainViewState = FAILED_RECORDING;
  voiceSearch = nil;
  [Sounds play:(AVAudioPlayer *)[Sounds sharedData].wrongWordSounds[ word ] delegate:self ];
}

@end
