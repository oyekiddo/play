//
//  PlayViewController.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/19/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "PlayViewController.h"

@implementation PlayViewController

@synthesize playViewController, wordScene, voiceSearch;

-(void) viewDidLoad
{
  [super viewDidLoad];
  one = [NSNumber numberWithInt:1];
  
  playViewController = (PlayViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"playViewController"];
  SKView *skView = (SKView *) self.view;
  skView.multipleTouchEnabled = false;
  
  wordScene = [[WordScene alloc] init: skView.bounds.size imageName:@"redback"];
  wordScene.scaleMode = SKSceneScaleModeAspectFill;
  [skView presentScene:wordScene];

  [wordScene setupHUD];
  [wordScene setupMessage];

  NSArray *canYouTellMeFilenames = @[ @"canYouTellMe", @"canYouTellMe2"];
  NSArray *wrongWordFilenames = @[ @"wronglaal", @"wrongpeela", @"wronghara", @"wrongneela", @"wrongsafed", @"wrongkaala"];
  NSArray *rightWordFilenames = @[ @"right", @"right2", @"right3", @"right4"];

  for (int i = 0; i < canYouTellMeFilenames.count; i++ ) {
    canYouTellMeSounds[i] = [[AVAudioPlayer alloc]
                          initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:canYouTellMeFilenames[i] ofType: @"wav" ]]
                          error:nil
                          ];
    [canYouTellMeSounds[i] setDelegate:self];
  }
  for (int i = 0; i < wrongWordFilenames.count; i++ ) {
    wrongWordSounds[i] = [[AVAudioPlayer alloc]
                          initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:wrongWordFilenames[i] ofType: @"wav" ]]
                          error:nil
                          ];
    [wrongWordSounds[i] setDelegate:self];
  }
  for (int i = 0; i < rightWordFilenames.count; i++ ) {
    rightWordSounds[i] = [[AVAudioPlayer alloc]
                          initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:rightWordFilenames[i] ofType: @"wav" ]]
                          error:nil
                          ];
    [rightWordSounds[i] setDelegate:self];
  }
  [[GameData sharedData] save];
  [[GameData sharedData] reset];
  trainViewState = IDLE;
  [self generateWord];
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
  [wrongWordSounds[ (int) word.wordType ] stop];
  [canYouTellMeSounds[ canYouTellIndex ] stop];
  [rightWordSounds[ rightWordIndex ] stop];
  if (voiceSearch != nil ) {
    [voiceSearch cancel];
    voiceSearch = nil;
  }
}
- (void) generateWord
{
  trainViewState = GENERATE_WORD;
  word = [[Word alloc] initRandom];
  [wordScene addWordToScene: word.name];
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  canYouTellIndex = [NSNumber numberWithInt:arc4random_uniform(2)].integerValue;
  [ canYouTellMeSounds[ canYouTellIndex ] play];
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
  NSArray *dict = [GameData sharedData].dict;
  NSMutableDictionary *wordDictionary = dict[ (int) word.wordType ];
  long numResults = [results.results count];
  
  Boolean found = false;
//  NSLog(@"Got Here numResults = %ld", numResults );
  if( numResults != 0 ) {
    for( int i = 0; i < numResults; i++ ) {
      NSString *sentence = results.results[i];
      NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      for( NSString *w in words ) {
//        NSLog([NSString stringWithFormat:@"TESTING %@", w]);
        for( NSString *w2 in wordDictionary ) {
//          NSLog([NSString stringWithFormat:@"comparing %@ with %@", w, w2]);
          if( [w compare: w2] == NSOrderedSame ) {
//            NSLog(@"found");
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
      [ wrongWordSounds[ (int) word.wordType ] play];
    } else {
      trainViewState = RECOGNIZED;
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
            [wordDictionary setObject:one forKey:w];
            //          NSLog([NSString stringWithFormat:@"adding key %@", w]);
          }
        }
      }
      [ wordScene incrementScore];
      [[GameData sharedData] save];
      rightWordIndex = [NSNumber numberWithInt:arc4random_uniform(4)].integerValue;
      [ rightWordSounds[ rightWordIndex ] play];
    }
  } else {
    trainViewState = ZERO_RESULTS;
    canYouTellIndex = [NSNumber numberWithInt:arc4random_uniform(2)].integerValue;
    [ canYouTellMeSounds[ canYouTellIndex ] play];
  }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
  trainViewState = FAILED_RECORDING;
  voiceSearch = nil;
  [ wrongWordSounds[ (int) word.wordType ] play];
}

@end
