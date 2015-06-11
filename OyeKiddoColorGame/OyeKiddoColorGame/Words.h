//
//  Words.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 6/10/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Words : NSObject

@property NSArray *names;
@property NSArray *labeledNames;
@property NSArray *hindiNames;

+(instancetype)sharedData;
+ (NSString *) random;

@end
