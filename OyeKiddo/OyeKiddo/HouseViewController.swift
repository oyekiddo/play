//
//  HouseViewController.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/18/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//

import UIKit
import SpriteKit

class HouseViewController: UIViewController, OEEventsObserverDelegate {
  
  let languageModelGenerator:OELanguageModelGenerator! = OELanguageModelGenerator()
  let eventsObserver:OEEventsObserver! = OEEventsObserver()
  
  let houseViewLanguageModel:String!
  let houseViewDictionary:String!
  
  required init(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    eventsObserver.delegate = self
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    let languageArray = ["LAAL", "NEELAA", "HARA", "PEELAA", "SAFED", "KAALAA"]
    var error:NSError? = languageModelGenerator.generateLanguageModelFromArray(languageArray, withFilesNamed: "HouseViewLanguageModel", forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
    if (error != nil) {
      println("Dynamic language generator reported error \(error?.description)")
    } else {
      houseViewLanguageModel = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName("HouseViewLanguageModel")
      houseViewDictionary = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName("HouseViewLanguageModel")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    if OEPocketsphinxController.sharedInstance().isListening {
      OEPocketsphinxController.sharedInstance().changeLanguageModelToFile(houseViewLanguageModel, withDictionary: houseViewDictionary )
    } else {
      OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(houseViewLanguageModel, dictionaryAtPath: houseViewDictionary, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let skView = view as SKView
    skView.multipleTouchEnabled = false
    
    let scene = HouseScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.Landscape.rawValue)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  @IBAction func toMapPressed(sender: AnyObject) {
    self.navigationController?.popToRootViewControllerAnimated(true);
  }
  
  //OpenEars methods begin
  func pocketsphinxDidReceiveHypothesis(hypothesis: NSString, recognitionScore: NSString, utteranceID: NSString) {
    if hypothesis as String == "SAFED" {
      self.navigationController?.popToRootViewControllerAnimated(true);
      OEPocketsphinxController.sharedInstance().stopListening()
    }
    println("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
  }
  
  func pocketsphinxDidStartListening() {
    println("Pocketsphinx is now listening.")
  }
  
  func pocketsphinxDidDetectSpeech() {
    println("Pocketsphinx has detected speech.")
  }
  
  func pocketsphinxDidDetectFinishedSpeech() {
    println("Pocketsphinx has detected a period of silence, concluding an utterance.")
  }
  
  func pocketsphinxDidStopListening() {
    println("Pocketsphinx has stopped listening.")
  }
  
  func pocketsphinxDidSuspendRecognition() {
    println("Pocketsphinx has suspended recognition.")
  }
  
  func pocketsphinxDidResumeRecognition() {
    println("Pocketsphinx has resumed recognition.")
  }
  
  func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
    println("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
  }
  
  func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String) {
    println("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
  }
  
  func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
    println("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
  }
  //OpenEars methods end
}
