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
static NSString* const SSGameDataDirtyKey = @"dirty";
static NSString* const SSGameDataDictKey = @"dict";

- (instancetype)initWithCoder:(NSCoder *)decoder
{
  self = [self init];
  if (self) {
    self.highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
    self.dirty = [decoder decodeBoolForKey:SSGameDataDirtyKey];
    NSDictionary *tempDictionary = [decoder decodeObjectForKey:SSGameDataDictKey];
    for( NSString *key in tempDictionary ) {
      self.dict[key] = tempDictionary[key];
    }
  }
  [self requestDataFromServer];
  return self;
}

-(id) init
{
  self.dict = [[NSMutableDictionary alloc] init];
  self.receivedData = [[NSMutableDictionary alloc] init];
  self.dirty = false;
  self.highScore = 0;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(sendDataToServerIfDirty) userInfo:nil repeats:true];
  [self requestDataFromServer];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
  [encoder encodeBool:self.dirty forKey:SSGameDataDirtyKey];
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
  self.dirty = true;
  NSLog( @"%@", [GameData sharedData].dict );
  NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
  [encodedData writeToFile:[GameData filePath] atomically:YES];
}

-(void) requestDataFromServer
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-52-25-134-140.us-west-2.compute.amazonaws.com:8080/ok/alternatives.json"]];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setTimeoutInterval:30.0];
  [request setHTTPMethod:@"GET"];
  self.receivedData[@"GET"] = [[NSMutableData alloc] init];
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  [connection start];
}

-(void) sendDataToServer
{
  NSError *error = nil;
  NSMutableDictionary *dict = [GameData sharedData].dict;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSUTF8StringEncoding error:&error];
  if (jsonData) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-52-25-134-140.us-west-2.compute.amazonaws.com:8080/ok/alternatives.json"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[jsonData length]];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    self.receivedData[@"POST"] = [[NSMutableData alloc] init];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

  } else {
    NSLog(@"Unable to serialize the data %@: %@", dict, error);
  }
}

-(void) sendDataToServerIfDirty
{
  if( self.dirty ) {
    [self sendDataToServer];
    self.dirty = false;
  }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSLog(@"DidReceiveResponse %@", response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [self.receivedData[connection.originalRequest.HTTPMethod] appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"Error is %@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSError *error = nil;
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData[connection.originalRequest.HTTPMethod] options:NSJSONReadingAllowFragments error:&error];
  if ([dictionary[@"status"]  isEqual: @"0"]) {
    if (self.dirty && [connection.originalRequest.HTTPMethod isEqualToString:@"GET"]) {
      // dictionary is dirty need to merge
      for( NSString *key in dictionary ) {
        Boolean changed = false;
        NSString *alternatives1 = dictionary[key];
        NSArray *wordsArray1 = [alternatives1 componentsSeparatedByString:@"," ];
        NSString *alternatives2 = self.dict[key];
        NSMutableArray *wordsArray2 = [[NSMutableArray alloc] initWithArray:[alternatives2 componentsSeparatedByString:@"," ]];
        for ( NSString *w in wordsArray1 ) {
          Boolean found = false;
          for( NSString *w2 in wordsArray2 ) {
            if( [w compare: w2] == NSOrderedSame ) {
              found = true;
              break;
            }
          }
          if (!found) {
            [wordsArray2 addObject: w];
            changed = true;
          }
        }
        if( changed ) {
          self.dict[key] = wordsArray2;
        }
      }
    } else {
      self.dict = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
  }
}

-(void)reset
{
  [GameData sharedData].score = 0;
}
@end
