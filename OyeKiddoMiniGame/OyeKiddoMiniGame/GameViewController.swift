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
