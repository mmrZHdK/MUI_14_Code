//
//  ViewController.swift
//  ToniAreal
//
//  Created by Hans Autor on 04.10.14.
//  Copyright (c) 2014 ZHdK. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

  @IBOutlet weak var webVC: UIWebView!
  var beacons: [CLBeacon]? = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Web View Scroller soll nicht bouncen
    self.webVC.scrollView.bounces = false
    
    // Prüfe, ob die Defaults gesetzt sind
    self.setPreferences()
    
    // Hole die Defaults und lade die entsprechende Seite
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let urlString = userDefaults.stringForKey( "url_preference" )
    
    let url = NSURL ( string:urlString! )
    let urlRequest = NSURLRequest ( URL:url )
    self.webVC.loadRequest( urlRequest )
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setPreferences() {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let urlString = userDefaults.stringForKey( "url_preference" )
    
    if urlString == nil {
      println( "String ist nil" )
      // bisher keine Preferences gesetzt, also schreibe Vorgabewerte rein
      let appDefaults = NSDictionary ( object: "http://data.zhdk.ch", forKey: "url_preference" )
      userDefaults.registerDefaults( appDefaults )
      userDefaults.synchronize()
    }
  }
  
  func neuLaden() {
    NSLog( "neu laden" )
    self.webVC.reload()
  }
  
  func reevaluateBeacons() {
    NSLog ( "reevaluating beacons" )
    
    var beaconJSON = ""
    var collectionJSON = ""
    for beacon in self.beacons! {
      beaconJSON = "major: \(beacon.major),"
      beaconJSON += "minor: \(beacon.minor),"

      switch beacon.proximity {
      case CLProximity.Far:
        beaconJSON += "proximity: 'far',"
      case CLProximity.Near:
        beaconJSON += "proximity: 'near',"
      case CLProximity.Immediate:
        beaconJSON += "proximity: 'immediate',"
      case CLProximity.Unknown:
        beaconJSON += "proximity: 'unknown',"
      }

      beaconJSON += "rssi: \(beacon.rssi)"
      if !collectionJSON.isEmpty { collectionJSON += ", " }
      collectionJSON += "{ \(beaconJSON) }"
    }
    
    let allJSON = "[ \(collectionJSON) ]"
    let jsCommand = "window.BeaconManager.updateBeacons( \(allJSON) );"
    NSLog( jsCommand )
    
    self.webVC.stringByEvaluatingJavaScriptFromString( jsCommand )
  }

}
