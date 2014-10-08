//
//  AppDelegate.swift
//  ToniAreal
//
//  Created by Hans Autor on 04.10.14.
//  Copyright (c) 2014 ZHdK. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
  
  var window: UIWindow?
  var locationManager: CLLocationManager?
  var lastProximity: CLProximity?
  
  
  func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    let uuidString = "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
    let beaconIdent = "Kontakt.io"
    let beaconUUID: NSUUID = NSUUID ( UUIDString: uuidString )
    let beaconRegion: CLBeaconRegion = CLBeaconRegion ( proximityUUID: beaconUUID, identifier: beaconIdent )
    
    locationManager = CLLocationManager()
    if locationManager!.respondsToSelector( "requestAlwaysAuthorization" ) {
      locationManager!.requestAlwaysAuthorization()
    }
    locationManager!.delegate = self
    locationManager!.pausesLocationUpdatesAutomatically = false
    
    locationManager!.startMonitoringForRegion( beaconRegion )
    locationManager!.startRangingBeaconsInRegion( beaconRegion )
    locationManager!.startUpdatingLocation()
    
    if application.respondsToSelector( "registerUserNotificationSettings:" ) {
      application.registerUserNotificationSettings(
        UIUserNotificationSettings(
          forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
          categories: nil
        )
      )
    }
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    let webVC = window?.rootViewController as ViewController
    webVC.neuLaden()
  }

  func applicationWillTerminate(application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

extension AppDelegate: CLLocationManagerDelegate {
  // Erweiterung der Klasse um Methoden, die das Protokoll für
  // LocationManager Delegates erfüllen
  
  func sendLocalNotificationWithMessage( message: String! ) {
    let notification: UILocalNotification = UILocalNotification()
    notification.alertBody = message
    UIApplication.sharedApplication().scheduleLocalNotification( notification )
  }
  
  func locationManager( manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
    
    NSLog( "didRangeBeacons" );
    var message: String = ""
    
    let viewController:ViewController = window!.rootViewController as ViewController
    viewController.beacons = beacons as [CLBeacon]!
    viewController.reevaluateBeacons()
    
    if beacons.count > 0 {
      let nearestBeacon: CLBeacon = beacons[ 0 ] as CLBeacon
      
      if nearestBeacon.proximity == lastProximity ||
        nearestBeacon.proximity == CLProximity.Unknown {
          return
      }
      lastProximity = nearestBeacon.proximity;
      let beaconSig = "\(nearestBeacon.major) / \(nearestBeacon.minor)"
      
      switch nearestBeacon.proximity {
        case CLProximity.Far:
          message = "Weit weg von Beacon \(beaconSig)"
        case CLProximity.Near:
          message = "Nahe an Beacon \(beaconSig)"
        case CLProximity.Immediate:
          message = "Direkt bei Beacon \(beaconSig)"
        case CLProximity.Unknown:
          return
      }
      
      NSLog( "%@", message )
      sendLocalNotificationWithMessage( message )
    }
  }
  
  func locationManager( manager: CLLocationManager!,
        didEnterRegion region: CLRegion! ) {
    
    manager.startRangingBeaconsInRegion( region as CLBeaconRegion )
    manager.startUpdatingLocation()
    
    let message = "Beacon Region betreten"
    NSLog( message )
    sendLocalNotificationWithMessage( message )
  }
  
  func locationManager( manager: CLLocationManager!,
        didExitRegion region: CLRegion! ) {
    
    manager.stopRangingBeaconsInRegion( region as CLBeaconRegion )
    manager.stopUpdatingLocation()
    
    let message = "Beacon Region verlassen"
    NSLog( message )
    sendLocalNotificationWithMessage( message )
  }
  
}
