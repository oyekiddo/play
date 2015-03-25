//
//  MapViewController.swift
//  OyeKiddo
//
//  Created by Gregory Omi on 3/18/15.
//  Copyright (c) 2015 OyeKiddo. All rights reserved.
//
import UIKit
import SpriteKit

class MapViewController: UIViewController, OEEventsObserverDelegate {

  @IBOutlet weak var toHouseButton: UIButton!
  @IBOutlet weak var toGameButton: UIButton!
  @IBOutlet weak var toJungleButton: UIButton!
  @IBOutlet weak var toTheaterButton: UIButton!
  
  let languageModelGenerator:OELanguageModelGenerator! = OELanguageModelGenerator()
  let eventsObserver:OEEventsObserver! = OEEventsObserver()

  var houseView:HouseViewController?
  var gameView:GameViewController?
  var jungleView:JungleViewController?
  var theaterView:TheaterViewController?
  let mapViewLanguageModel:String!
  let mapViewDictionary:String!

  required init(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    eventsObserver.delegate = self
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    let languageArray = ["LAAL", "NEELAA", "HARA", "PEELAA", "SAFED", "KAALAA"]
    var error:NSError? = languageModelGenerator.generateLanguageModelFromArray(languageArray, withFilesNamed: "MapViewLanguageModel", forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
    if (error != nil) {
      println("Dynamic language generator reported error \(error?.description)")
    } else {
      mapViewLanguageModel = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName("MapViewLanguageModel")
      mapViewDictionary = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName("MapViewLanguageModel")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    houseView = self.storyboard?.instantiateViewControllerWithIdentifier("houseView") as? HouseViewController
    gameView = self.storyboard?.instantiateViewControllerWithIdentifier("gameView") as? GameViewController
    jungleView = self.storyboard?.instantiateViewControllerWithIdentifier("jungleView") as? JungleViewController
    theaterView = self.storyboard?.instantiateViewControllerWithIdentifier("theaterView") as? TheaterViewController
    OEPocketsphinxController.sharedInstance().setActive( true, error: nil )
    if OEPocketsphinxController.sharedInstance().isListening {
      OEPocketsphinxController.sharedInstance().changeLanguageModelToFile(mapViewLanguageModel, withDictionary: mapViewDictionary )
    } else {
      OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(mapViewLanguageModel, dictionaryAtPath: mapViewDictionary, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let skView = view as SKView
    skView.multipleTouchEnabled = false
    
    let size = skView.bounds.size
    toHouseButton.center = CGPointMake(size.width * 0.2, size.height * 0.45 )
    toGameButton.center = CGPointMake(size.width * 0.175, size.height * 0.85 )
    toJungleButton.center = CGPointMake(size.width * 0.7, size.height * 0.15 )
    toTheaterButton.center = CGPointMake(size.width * 0.8, size.height * 0.9 )
    
    let houseCenter = toHouseButton.center
    let scene = MapScene(size: skView.bounds.size)
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
  
  @IBAction func toHousePressed(sender: AnyObject) {
    self.navigationController?.pushViewController( houseView!, animated: true )
  }
  
  @IBAction func toGamePressed(sender: AnyObject) {
    self.navigationController?.pushViewController( gameView!, animated: true )
  }
  
  @IBAction func toJunglePressed(sender: AnyObject) {
    self.navigationController?.pushViewController( jungleView!, animated: true )
  }
  
  @IBAction func toTheaterPressed(sender: AnyObject) {
    self.navigationController?.pushViewController( theaterView!, animated: true )
  }

  //OpenEars methods begin
  func pocketsphinxDidReceiveHypothesis(hypothesis: NSString, recognitionScore: NSString, utteranceID: NSString) {
    switch hypothesis as String {
    case "HARA":
      self.navigationController?.pushViewController( houseView!, animated: true )
      OEPocketsphinxController.sharedInstance().stopListening()
    case "PEELAA":
      self.navigationController?.pushViewController( gameView!, animated: true )
      OEPocketsphinxController.sharedInstance().stopListening()
    case "NEELAA":
      self.navigationController?.pushViewController( theaterView!, animated: true )
      OEPocketsphinxController.sharedInstance().stopListening()
    case "LAAL":
      self.navigationController?.pushViewController( jungleView!, animated: true )
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
