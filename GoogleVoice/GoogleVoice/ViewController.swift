//
//  ViewController.swift
//  GoogleVoice
//
//  Created by Gregory Omi on 5/8/15.
//  Copyright (c) 2015 GregoryOmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let url = NSURL (string: "https://www.google.com/intl/en/chrome/demos/speech.html");
    let requestObj = NSURLRequest(URL: url!);
    webView.loadRequest(requestObj);
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

