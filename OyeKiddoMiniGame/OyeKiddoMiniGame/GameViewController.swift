//
//  GameViewController.swift
//  OyeKiddoMiniGame
//
//  Created by Gregory Omi on 5/7/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SpeechKitDelegate, SKRecognizerDelegate {

  var scene: GameScene!

  @objc var SpeechKitApplicationKey = [CUnsignedChar]( arrayLiteral: 0x92, 0x46, 0x0c, 0x43, 0x8d, 0x56, 0x86, 0xd3, 0x25, 0x16, 0xff, 0xb5, 0x1d, 0x4d, 0xa7, 0x4a, 0x44, 0x6c, 0xf3, 0xd5, 0xcc, 0xab, 0xdf, 0x76, 0xa0, 0xc5, 0xc2, 0x7c, 0x59, 0x3e, 0xea, 0xeb, 0x84, 0xf7, 0x2e, 0x12, 0x4d, 0xb4, 0xe5, 0x72, 0xcb, 0xe4, 0x27, 0xe8, 0x31, 0xce, 0x32, 0x75, 0x3a, 0x26, 0x4a, 0x07, 0xd1, 0x29, 0x7d, 0x71, 0xef, 0x3f, 0xed, 0x48, 0x7d, 0xd8, 0x33, 0x02 )
  

  enum TransactionState {
    case TS_IDLE
    case TS_INITIAL
    case TS_RECORDING
    case TS_PROCESSING
  }
  
  var transactionState = TransactionState.TS_INITIAL

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let skView = view as! SKView
    skView.multipleTouchEnabled = false
    
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    
    skView.presentScene(scene)
    SpeechKit.setupWithID( "NMDPTRIAL_greg_omi_gmail_com20150504222803",
      host: "sandbox.nmdp.nuancemobility.net",
      port:443,
      useSSL:false,
      delegate:nil
      )
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func shouldAutorotate() -> Bool {
    return false
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int( UIInterfaceOrientationMask.Portrait.rawValue )
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  func recognizerDidBeginRecording(recognizer: SKRecognizer!) {
    transactionState = TransactionState.TS_RECORDING
  }
  
  func recognizerDidFinishRecording(recognizer: SKRecognizer!) {
    transactionState = TransactionState.TS_PROCESSING
  }
  
  func recognizer(recognizer: SKRecognizer!, didFinishWithResults results: SKRecognition!) {
    var numOfResults = results.results.count
    
    transactionState = TransactionState.TS_IDLE
    
  }
  
  func recognizer(recognizer: SKRecognizer!, didFinishWithError error: NSError!, suggestion: String!) {
    transactionState = TransactionState.TS_IDLE
  }
}
