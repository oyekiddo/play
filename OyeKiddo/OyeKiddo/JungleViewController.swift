//
//  JungleViewController.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/18/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//

import UIKit
import SpriteKit

class JungleViewController: UIViewController, OEEventsObserverDelegate {
  
  let eventsObserver:OEEventsObserver! = OEEventsObserver()
  var houseView:HouseViewController?
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    houseView = self.storyboard?.instantiateViewControllerWithIdentifier("houseView") as? HouseViewController

    let skView = view as! SKView
    skView.multipleTouchEnabled = false
    
    let scene = JungleScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  }
  
  override func viewDidAppear(animated: Bool) {
    eventsObserver.delegate = self
  }
  
  override func viewDidDisappear(animated: Bool) {
    eventsObserver.delegate = nil
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
  func pocketsphinxDidReceiveHypothesis(hypothesis: String, recognitionScore: String, utteranceID: String) {
    switch hypothesis {
    case "HARA":
      self.navigationController?.pushViewController( houseView!, animated: true )
    case "SAFED":
      self.navigationController?.popToRootViewControllerAnimated(true);
    case "GREEN":
      self.navigationController?.pushViewController( houseView!, animated: true )
    case "WHITE":
      self.navigationController?.popToRootViewControllerAnimated(true);
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
