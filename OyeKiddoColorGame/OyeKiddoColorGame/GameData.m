//
//  GameData.m
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/25/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import "WordType.h"
#import "GameData.h"

@implementation GameData

static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataDictKey = @"dict";

- (instancetype)initWithCoder:(NSCoder *)decoder
{
  self = [self init];
  if (self) {
    _highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
    NSArray *tempArray = [decoder decodeObjectForKey:SSGameDataDictKey];
    for( int i=0; i < tempArray.count; i++ ) {
      _dict[i] = [[NSMutableDictionary alloc] initWithDictionary:tempArray[i]];
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
  [encoder encodeObject:self.dict forKey:SSGameDataDictKey];
}

+ (instancetype)sharedData
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once( &onceToken, ^{ sharedInstance = [self loadInstance];; } );
  
  return sharedInstance;
}

+(NSString*)filePath
{
  static NSString* filePath = nil;
  if (!filePath) {
    filePath =
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
     stringByAppendingPathComponent:@"gamedata"];
  }
  return filePath;
}

+(instancetype)loadInstance
{
  NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
  if (decodedData) {
    GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
    return gameData;
  }
  
  return [[GameData alloc] init];
}

-(void)save
{
  NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
  [encodedData writeToFile:[GameData filePath] atomically:YES];
  NSLog( @"%@", [self dict] );
}

-(id) init
{
  int capacity = (int) numWords;
  self.dict = [[NSMutableArray alloc] initWithCapacity:(int) capacity];
  self.highScore = 0;
  return self;
}

-(void)reset
{
  self.score = 0;
}
@end
