//
//  PlayViewController.swift
//  OyeKiddoColorGame
//
//  Created by Gregory Omi on 5/15/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

import UIKit
import SpriteKit

@objc class PlayViewController: UIViewController, SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate {
  
  enum TransactionState { case TS_IDLE, TS_INITIAL, TS_RECORDING, TS_PROCESSING }
  
  var transactionState: TransactionState = TransactionState.TS_INITIAL
  var playView:PlayViewController?
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    playView = self.storyboard?.instantiateViewControllerWithIdentifier("playView") as? PlayViewController
    
    let skView = view as! SKView
    skView.multipleTouchEnabled = false
    
    let scene = PlayScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  }

  func recognizerDidBeginRecording( recognizer: SKRecognizer )
  {
    transactionState = TransactionState.TS_RECORDING
  }
  
  func recognizerDidFinishRecording( recognizer: SKRecognizer )
  {
    transactionState = TransactionState.TS_PROCESSING;
  }
  
  func recognizer( recognizer: SKRecognizer, didFinishWithResults results:SKRecognition )
  {
  }
  
  func recognizer( recognizer: SKRecognizer, didFinishWithError error: NSError, suggestion: String )
  {
  }

}
