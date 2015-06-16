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

-(id) init
{
  self.dict = [[NSMutableDictionary alloc] init];
  self.highScore = 0;
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

-(void) requestDataFromServer
{
  
}

-(void) sendDataToServer
{
  NSError *error = nil;
  NSMutableDictionary *dict = [GameData sharedData].dict;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
  if (jsonData) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://host:port/oyekiddo/addToDictionary.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[jsonData length]];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:30.0];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn)
    {
      NSLog(@"Connection successfull");
    }
    else
    {
      NSLog(@"connection could not be made");
      
    }
    
  } else {
    NSLog(@"Unable to serialize the data %@: %@", dict, error);
  }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSLog(@"DidReceiveResponse %@", response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  NSLog(@"DidReceiveData");
  NSLog(@"DATA %@",data);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"Error is");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  
//  NSLog(@"Succeeded! Received %d bytes of data",[webData length]);
//  NSLog(@"Data is %@",webData);
//  
//  
//  
//  // NSLog(@"receivedData%@",_receivedData);
//  
//  NSString *responseText = [[NSString alloc] initWithData:webData encoding: NSASCIIStringEncoding];
//  NSLog(@"Response: %@", responseText);//holds textfield entered value
//  
//  NSLog(@"");
//  
//  NSString *newLineStr = @"\n";
//  responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
//  
//  NSLog(@"ResponesText %@",responseText);
  
}

-(void)reset
{
  [GameData sharedData].score = 0;
}
@end
