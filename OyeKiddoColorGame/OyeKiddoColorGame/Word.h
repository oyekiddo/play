//
//  Word.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/19/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordType.h"

@interface Word : NSObject {
  WordType wordType;
}

-(id) init:(WordType) wordType;
-(id) initRandom;
-(NSString *) name;
-(NSString *) labeledName;
-(NSString *) hindiName;

@property(readwrite) WordType wordType;

@end
