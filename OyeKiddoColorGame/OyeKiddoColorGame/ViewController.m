//
//  ColorGameViewController.m
//  DMRecognizer
//
// Copyright 2010, Nuance Communications Inc. All rights reserved.
//
// Nuance Communications, Inc. provides this document without representation
// or warranty of any kind. The information in this document is subject to
// change without notice and does not represent a commitment by Nuance
// Communications, Inc. The software and/or databases described in this
// document are furnished under a license agreement and may be used or
// copied only in accordance with the terms of such license agreement.
// Without limiting the rights under copyright reserved herein, and except
// as permitted by such license agreement, no part of this document may be
// reproduced or transmitted in any form or by any means, including, without
// limitation, electronic, mechanical, photocopying, recording, or otherwise,
// or transferred to information storage and retrieval systems, without the
// prior written permission of Nuance Communications, Inc.
//
// Nuance, the Nuance logo, Nuance Recognizer, and Nuance Vocalizer are
// trademarks or registered trademarks of Nuance Communications, Inc. or its
// affiliates in the United States and/or other countries. All other
// trademarks referenced herein are the property of their respective owners.
//

#import "ViewController.h"
#import "PlayViewController.h"
#import "TrainViewController.h"
#import "GameData.h"

/**
 * The login parameters should be specified in the following manner:
 *
 * const unsigned char SpeechKitApplicationKey[] =
 * {
 *     0x38, 0x32, 0x0e, 0x46, 0x4e, 0x46, 0x12, 0x5c, 0x50, 0x1d,
 *     0x4a, 0x39, 0x4f, 0x12, 0x48, 0x53, 0x3e, 0x5b, 0x31, 0x22,
 *     0x5d, 0x4b, 0x22, 0x09, 0x13, 0x46, 0x61, 0x19, 0x1f, 0x2d,
 *     0x13, 0x47, 0x3d, 0x58, 0x30, 0x29, 0x56, 0x04, 0x20, 0x33,
 *     0x27, 0x0f, 0x57, 0x45, 0x61, 0x5f, 0x25, 0x0d, 0x48, 0x21,
 *     0x2a, 0x62, 0x46, 0x64, 0x54, 0x4a, 0x10, 0x36, 0x4f, 0x64
 * };
 *
 * Please note that all the specified values are non-functional
 * and are provided solely as an illustrative example.
 *
 */
const unsigned char SpeechKitApplicationKey[] = {0x92, 0x46, 0x0c, 0x43, 0x8d, 0x56, 0x86, 0xd3, 0x25, 0x16, 0xff, 0xb5, 0x1d, 0x4d, 0xa7, 0x4a, 0x44, 0x6c, 0xf3, 0xd5, 0xcc, 0xab, 0xdf, 0x76, 0xa0, 0xc5, 0xc2, 0x7c, 0x59, 0x3e, 0xea, 0xeb, 0x84, 0xf7, 0x2e, 0x12, 0x4d, 0xb4, 0xe5, 0x72, 0xcb, 0xe4, 0x27, 0xe8, 0x31, 0xce, 0x32, 0x75, 0x3a, 0x26, 0x4a, 0x07, 0xd1, 0x29, 0x7d, 0x71, 0xef, 0x3f, 0xed, 0x48, 0x7d, 0xd8, 0x33, 0x02};
@implementation ViewController

@synthesize trainButton, playButton, voiceSearch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  /**
   * The login parameters should be specified in the following manner:
   *
   *  [SpeechKit setupWithID:@"ExampleSpeechKitSampleID"
   *                    host:@"ndev.server.name"
   *                    port:1000
   *                  useSSL:NO
   *                delegate:self];
   *
   * Please note that all the specified values are non-functional
   * and are provided solely as an illustrative example.
   */
  [SpeechKit setupWithID:@"NMDPTRIAL_greg_omi_gmail_com20150504222803"
                    host:@"sandbox.nmdp.nuancemobility.net"
                    port:443
                  useSSL:NO
                delegate:nil];
  NSArray *dict = [GameData sharedData].dict;
  int count = numWords;
  if( dict.count < count ) {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray: @[
                                                                          @{
                                                                            @"\u0906\u0913": [NSNumber numberWithInt: 1],
                                                                            @"\u0915\u094d\u0932\u093e\u0909\u0921": [NSNumber numberWithInt: 1],
                                                                            @"\u091c\u093e\u0913": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0949\u0907\u095b": [NSNumber numberWithInt: 9],
                                                                            @"\u0928\u0949\u0907\u095b.": [NSNumber numberWithInt: 1],
                                                                            @"\u092c\u0924\u093e\u0913": [NSNumber numberWithInt: 1],
                                                                            @"\u092c\u093e\u0939\u094b\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u0939\u093e": [NSNumber numberWithInt: 4],
                                                                            @"\u0930\u093e\u092e": [NSNumber numberWithInt: 3],
                                                                            @"\u0930\u093e\u0935\u0923": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u093e\u0939\u0941\u0932": [NSNumber numberWithInt: 4],
                                                                            @"\u0930\u093e\u0939\u094b": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u093e\u0939\u094b\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u0932\u093e\u0913": [NSNumber numberWithInt: 4],
                                                                            @"\u0932\u093e\u0932": [NSNumber numberWithInt: 1],
                                                                            @"\u0932\u093e\u0939\u094c\u0930": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u0939\u093e\u0901": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u0939\u093e\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u093e\u0913": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u093e\u0939": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u094b": [NSNumber numberWithInt: 1],
                                                                            @"\u0939\u0942\u0901": [NSNumber numberWithInt: 2],
                                                                            @"\u0939\u0942\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u0939\u0948": [NSNumber numberWithInt: 1]
                                                                            },
                                                                          @{
                                                                            @"\u0905\u0930\u0947": [NSNumber numberWithInt: 1],
                                                                            @"\u0924\u0947\u0935\u0930": [NSNumber numberWithInt: 1],
                                                                            @"\u0926\u0947\u0935\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0927\u0928\u094d\u092f\u0935\u093e\u0926": [NSNumber numberWithInt: 6],
                                                                            @"\u0927\u0928\u094d\u092f\u0935\u093e\u0926\u094d": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0949\u0907\u095b": [NSNumber numberWithInt: 3],
                                                                            @"\u092a\u0930\u093f\u0935\u093e\u0930": [NSNumber numberWithInt: 1],
                                                                            @"\u092a\u0940\u0932\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u092f\u0941\u0935\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u093f\u0935\u093e\u091c": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u0947\u0935\u093e": [NSNumber numberWithInt: 3],
                                                                            @"\u0935\u093f\u0935\u093e\u0926": [NSNumber numberWithInt: 3],
                                                                            @"\u0935\u093f\u0935\u093e\u0939": [NSNumber numberWithInt: 3],
                                                                            @"\u0938\u0947\u0935\u093e": [NSNumber numberWithInt: 5]
                                                                            },
                                                                          @{
                                                                            @"\u0906\u092f\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0906\u0930\u091f\u0940": [NSNumber numberWithInt: 1],
                                                                            @"\u0906\u0930\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0915\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0949\u0907\u095b": [NSNumber numberWithInt: 4],
                                                                            @"\u092d\u093e\u0930\u0924": [NSNumber numberWithInt: 2],
                                                                            @"\u0939\u092e\u093e\u0930\u093e": [NSNumber numberWithInt: 6],
                                                                            @"\u0939\u0930": [NSNumber numberWithInt: 2],
                                                                            @"\u0939\u0930\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0939\u093e": [NSNumber numberWithInt: 8],
                                                                            @"\u0939\u093e\u0901": [NSNumber numberWithInt: 3],
                                                                            @"\u0939\u093e\u0930\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u0939\u093e\u0935\u095c\u093e": [NSNumber numberWithInt: 1]
                                                                            },
                                                                          @{
                                                                            @"\u0915\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0917\u092f\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0924\u0947\u0930\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0926\u093f\u092f\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0927\u0928\u094d\u092f\u0935\u093e\u0926": [NSNumber numberWithInt: 7],
                                                                            @"\u0928\u0939\u0940\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0940\u0932\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0947\u0924\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u0928\u0947\u0939\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u0928\u0949\u0907\u095b": [NSNumber numberWithInt: 7],
                                                                            @"\u092a\u094d\u0930\u093f\u092f\u093e": [NSNumber numberWithInt: 3],
                                                                            @"\u092a\u094d\u0932\u0947\u092c\u0949\u092f": [NSNumber numberWithInt: 1],
                                                                            @"\u092e\u0939\u093f\u0932\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u092e\u0940\u0930\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u092e\u0947\u0930\u093e": [NSNumber numberWithInt: 8],
                                                                            @"\u092e\u0947\u0930\u0947": [NSNumber numberWithInt: 1],
                                                                            @"\u092e\u0947\u0935\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u092e\u0947\u0935\u093e\u0924": [NSNumber numberWithInt: 1],
                                                                            @"\u0930\u0939\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u093f\u0935\u093e\u0926": [NSNumber numberWithInt: 1],
                                                                            @"\u0935\u093f\u0935\u093e\u0939": [NSNumber numberWithInt: 2],
                                                                            @"\u0936\u0928\u093f\u0935\u093e\u0930": [NSNumber numberWithInt: 1],
                                                                            @"\u0938\u0947\u0935\u093e": [NSNumber numberWithInt: 5]
                                                                            },
                                                                          @{
                                                                            @"\u090f\u0915": [NSNumber numberWithInt: 1],
                                                                            @"\u0928\u0949\u0907\u095b": [NSNumber numberWithInt: 13],
                                                                            @"\u095e\u093e\u0907\u0932\u0947\u0902": [NSNumber numberWithInt: 1],
                                                                            @"\u092b\u094d\u0930\u0948\u0902\u0915": [NSNumber numberWithInt: 2],
                                                                            @"\u0938\u095e\u0930": [NSNumber numberWithInt: 1],
                                                                            @"\u0938\u092b\u093e\u0908": [NSNumber numberWithInt: 3],
                                                                            @"\u0938\u092b\u0947\u0926": [NSNumber numberWithInt: 24],
                                                                            @"\u0938\u095e\u0947\u0926": [NSNumber numberWithInt: 11],
                                                                            @"\u0938\u092c\u0938\u0947": [NSNumber numberWithInt: 1],
                                                                            @"\u0938\u0930": [NSNumber numberWithInt: 2],
                                                                            @"\u0938\u0949\u092b\u094d\u091f\u0935\u0947\u092f\u0930": [NSNumber numberWithInt: 3],
                                                                            @"\u0939\u0948": [NSNumber numberWithInt: 1]
                                                                            },
                                                                          @{
                                                                            @"\u0915\u0939\u093e": [NSNumber numberWithInt: 3],
                                                                            @"\u0915\u093e": [NSNumber numberWithInt: 8],
                                                                            @"\u0915\u093e\u092c\u093e": [NSNumber numberWithInt: 3],
                                                                            @"\u0915\u093e\u0932\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u0915\u094d\u092f\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0918\u0902\u091f\u093e": [NSNumber numberWithInt: 1],
                                                                            @"\u0926\u093f\u0916\u093e\u0935\u093e": [NSNumber numberWithInt: 2],
                                                                            @"\u0939\u0935\u093e": [NSNumber numberWithInt: 3],
                                                                            @"\u0939\u0941\u0906": [NSNumber numberWithInt: 1]
                                                                            }
                                                                          ]
                                  ];
    
    for( int i=0; i < tempArray.count; i++ ) {
      [GameData sharedData].dict[i] = [[NSMutableDictionary alloc] initWithDictionary:tempArray[i]];
    }
  }
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
}

- (IBAction)trainButton:(id)sender
{
  TrainViewController *trainViewController = (TrainViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"trainViewController"];
  [self.navigationController pushViewController: trainViewController  animated: true ];
}

- (IBAction)playButton:(id)sender
{
  PlayViewController *playViewController = (PlayViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"playViewController"];
  [self.navigationController pushViewController: playViewController  animated: true ];
}

- (void) destroyed
{
  // Debug - Uncomment this code and fill in your app ID below, and set
  // the Main Window nib to MainWindow_Debug (in DMRecognizer-Info.plist)
  // if you need the ability to change servers in DMRecognizer
  //
  //[SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
  //                  host:INSERT_YOUR_HOST_ADDRESS_HERE
  //                  port:INSERT_YOUR_HOST_PORT_HERE[[portBox text] intValue]
  //                useSSL:NO
  //              delegate:self];
  //
  // Set earcons to play
  //SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
  //SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
  //SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
  //
  //[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
  //[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
  //[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
}


@end
