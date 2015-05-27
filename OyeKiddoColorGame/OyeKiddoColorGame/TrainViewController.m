//
//  TrainViewController.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/18/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "Word.h"
#import "TrainViewController.h"
#import "GameData.h"

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
  
  NSArray *canYouSayFilenames = @[ @"laal", @"peela2", @"hara", @"neela", @"safed", @"kala2"];
  NSArray *didntGetFilenames = @[ @"didntgetlaal", @"didntgetpeela", @"didntgethara", @"didntgetneela", @"didntgetsafed", @"didntgetkala"];
  
  WordType count = numWords;
  for (int i = 0; i < (int) count; i++ ) {
    canYouSaySounds[i] = [[AVAudioPlayer alloc]
                          initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:canYouSayFilenames[i] ofType: @"wav" ]]
                          error:nil
                          ];
    [canYouSaySounds[i] setDelegate:self];
    didntGetSounds[i] = [[AVAudioPlayer alloc]
                         initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:didntGetFilenames[i] ofType: @"wav" ]]
                         error:nil
                         ];
    [didntGetSounds[i] setDelegate:self];
  }

  lessonNumber = 0;
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
  [canYouSaySounds[lessonNumber] stop];
  [didntGetSounds[lessonNumber] stop];
  if (voiceSearch != nil ) {
    [voiceSearch cancel];
    voiceSearch = nil;
  }
}

- (void) startLesson
{
  trainViewState = START_LESSON;
  word = [[Word alloc] init:(WordType) lessonNumber ];
  [wordScene addWordToScene: word.labeledName];
  [wordScene setMessageText:@"Please Wait" color:[SKColor redColor]];
  [canYouSaySounds[lessonNumber] play];
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
  NSLog(@"Got results.");
  NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
 
  NSString *hindiName = word.hindiName;
  NSArray *dict = [GameData sharedData].dict;
  NSMutableDictionary *wordDictionary;
  if( dict.count <= lessonNumber ) {
    wordDictionary = [NSMutableDictionary dictionary];
    [GameData sharedData].dict[lessonNumber] = wordDictionary;
    [wordDictionary setObject:[NSNumber numberWithInt: 1] forKey:hindiName];
//    NSLog([NSString stringWithFormat:@"adding key %@", hindiName]);
  } else {
    wordDictionary = [GameData sharedData].dict[lessonNumber];
  }
  long numResults = [results.results count];
  
  Boolean found = false;
  NSLog(@"Got Here numResults = %ld", numResults );
  for( int i = 0; i < numResults; i++ ) {
    NSString *sentence = results.results[i];
    NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for( NSString *w in words ) {
//      NSLog([NSString stringWithFormat:@"TESTING %@", w]);
      for( NSString *w2 in wordDictionary ) {
//        NSLog([NSString stringWithFormat:@"comparing %@ with %@", w, w2]);
        if( [w compare: w2] == NSOrderedSame ) {
          NSLog(@"found");
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
    [didntGetSounds[lessonNumber] play];
  } else {
    trainViewState = RECOGNIZED;
    WordType count = numWords;
    if( lessonNumber < (count - 1) ) {
      [wordScene removeWordFromScene];
      lessonNumber++;
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
  [didntGetSounds[lessonNumber] play];
}

@end
