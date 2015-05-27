//
//  TrainViewState.h
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/25/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

#ifndef OyeKiddoColorGame_TrainViewState_h
#define OyeKiddoColorGame_TrainViewState_h

typedef enum : NSUInteger {
  IDLE,
  START_LESSON,
  START_RECORDING,
  RECOGNIZED,
  DIDNT_RECOGNIZE,
  FAILED_RECORDING,
  GENERATE_WORD,
  ZERO_RESULTS
} TrainViewState;

#endif
