//
//  TheaterViewController.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/18/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//

import UIKit
import SpriteKit

class TheaterViewController: UIViewController, OEEventsObserverDelegate {

  let languageModelGenerator:OELanguageModelGenerator! = OELanguageModelGenerator()
  let eventsObserver:OEEventsObserver! = OEEventsObserver()
  
  var houseView:HouseViewController?
  let theaterViewLanguageModel:String!
  let theaterViewDictionary:String!
  
  required init(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    eventsObserver.delegate = self
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    let languageArray = ["LAAL", "NEELAA", "HARA", "PEELAA", "SAFED", "KAALAA"]
    var error:NSError? = languageModelGenerator.generateLanguageModelFromArray(languageArray, withFilesNamed: "TheaterViewLanguageModel", forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
    if (error != nil) {
      println("Dynamic language generator reported error \(error?.description)")
    } else {
      theaterViewLanguageModel = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName("TheaterViewLanguageModel")
      theaterViewDictionary = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName("TheaterViewLanguageModel")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    houseView = self.storyboard?.instantiateViewControllerWithIdentifier("houseView") as? HouseViewController
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    if OEPocketsphinxController.sharedInstance().isListening {
      OEPocketsphinxController.sharedInstance().changeLanguageModelToFile(theaterViewLanguageModel, withDictionary: theaterViewDictionary )
    } else {
      OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(theaterViewLanguageModel, dictionaryAtPath: theaterViewDictionary, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
  }
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let skView = view as SKView
    skView.multipleTouchEnabled = false
    
    let scene = TheaterScene(size: skView.bounds.size)
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
  
  @IBAction func toHousePressed(sender: AnyObject) {
    self.navigationController?.pushViewController( houseView!, animated: true )
  }
  
  //OpenEars methods begin
  func pocketsphinxDidReceiveHypothesis(hypothesis: NSString, recognitionScore: NSString, utteranceID: NSString) {
    switch hypothesis as String {
    case "HARA":
      self.navigationController?.pushViewController( houseView!, animated: true )
      OEPocketsphinxController.sharedInstance().stopListening()
    case "SAFED":
      self.navigationController?.popToRootViewControllerAnimated(true);
      OEPocketsphinxController.sharedInstance().stopListening()
    default:
      break
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
