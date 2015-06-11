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
    NSDictionary *tempDictionary = [decoder decodeObjectForKey:SSGameDataDictKey];
    for( NSString *key in tempDictionary ) {
      _dict[key] = [[NSMutableDictionary alloc] initWithDictionary:tempDictionary[key]];
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
  dispatch_once( &onceToken, ^{ sharedInstance = [self loadInstance]; } );
  
  return sharedInstance;
}

+(NSString*)filePath
{
  static NSString* filePath = nil;
  if (!filePath) {
    filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
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
  NSLog( @"%@", [GameData sharedData].dict );
  NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
  [encodedData writeToFile:[GameData filePath] atomically:YES];
}

-(id) init
{
  self.dict = [[NSMutableDictionary alloc] init];
  self.highScore = 0;
  return self;
}

-(void)reset
{
  [GameData sharedData].score = 0;
}
@end
