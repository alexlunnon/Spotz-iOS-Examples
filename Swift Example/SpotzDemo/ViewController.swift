//
//  ViewController.swift
//  SpotzDemo
//
//  Created by Daniel Sykes-Turner on 13/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.loadRequest(NSURLRequest(URL: NSURL(string: "http://localz.co/spotz-web-examples/index.html")!))
        
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("Spotz Inside")
            
            if let payload:NSDictionary = note.object as? NSDictionary
            {
                if let spotz: Spotz = payload["spotz"] as? Spotz
                {
                    // Spotz Data to JSON
                    var data:NSDictionary = spotz.data
                    var spotzData:NSData = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: nil)!
                    var spotzDataJSON:NSString = NSString(bytes: spotzData.bytes, length: spotzData.length, encoding: NSUTF8StringEncoding)!
                    
                    // Spotz Name to JSON
                    var spotzName:NSDictionary = ["id":spotz.id,"name":spotz.name]
                    var spotzNameData:NSData = NSJSONSerialization.dataWithJSONObject(spotzName, options: nil, error: nil)!
                    var spotzNameJSON:NSString = NSString(bytes: spotzNameData.bytes, length: spotzNameData.length, encoding: NSUTF8StringEncoding)!
                    
                    // Either a beacon or a geofence will be passed over
                    if let beacon: SpotzBeacon = payload["beacon"] as? SpotzBeacon
                    {
                        // Spotz Beacon to JSON
                        var spotzBeacon = ["uuid":beacon.uuid,"major":NSNumber(int: beacon.major),"minor":NSNumber(int: beacon.minor),"serial":beacon.serial]
                        var spotzBeaconData:NSData = NSJSONSerialization.dataWithJSONObject(spotzBeacon, options: nil, error: nil)!
                        var spotzBeaconJSON:NSString = NSString(bytes: spotzBeaconData.bytes, length: spotzBeaconData.length, encoding: NSUTF8StringEncoding)!
                        
                        var str:NSString = NSString(format: "monitorData(%@,%@,%@)", spotzNameJSON, spotzBeaconJSON, spotzDataJSON)

                        self.webview.stringByEvaluatingJavaScriptFromString(str)
                    }
                    else if let geofence: SpotzGeofence = payload["geofence"] as? SpotzGeofence
                    {
                        // Spotz Geofence to JSON
                        var spotzGeofence = ["latitude":NSNumber(float: geofence.latitude),"longitude":NSNumber(float: geofence.longitude),"radius":NSNumber(float: geofence.radius)]
                        var spotzGeofenceData:NSData = NSJSONSerialization.dataWithJSONObject(spotzGeofence, options: nil, error: nil)!
                        var spotzGeofenceJSON:NSString = NSString(bytes: spotzGeofenceData.bytes, length: spotzGeofenceData.length, encoding: NSUTF8StringEncoding)!
                        
                        var str:NSString = NSString(format: "monitorData(%@,%@,%@)", spotzNameJSON, spotzGeofenceJSON, spotzDataJSON)
                        
                        self.webview.stringByEvaluatingJavaScriptFromString(str)
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("Spotz Outside")
            
            if let payload:NSDictionary = note.object as? NSDictionary
            {
                if let spotz: Spotz = payload["spotz"] as? Spotz
                {
                    // Spotz Data to JSON
                    var data:NSDictionary = spotz.data
                    var spotzData:NSData = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: nil)!
                    var spotzDataJSON:NSString = NSString(bytes: spotzData.bytes, length: spotzData.length, encoding: NSUTF8StringEncoding)!
                    
                    // Spotz Name to JSON
                    var spotzName:NSDictionary = ["id":spotz.id,"name":spotz.name]
                    var spotzNameData:NSData = NSJSONSerialization.dataWithJSONObject(spotzName, options: nil, error: nil)!
                    var spotzNameJSON:NSString = NSString(bytes: spotzNameData.bytes, length: spotzNameData.length, encoding: NSUTF8StringEncoding)!
                    
                    // Either a beacon or a geofence will be passed over
                    if let beacon: SpotzBeacon = payload["beacon"] as? SpotzBeacon
                    {
                        // Spotz Beacon to JSON
                        var spotzBeacon = ["uuid":beacon.uuid,"major":NSNumber(int: beacon.major),"minor":NSNumber(int: beacon.minor),"serial":beacon.serial]
                        var spotzBeaconData:NSData = NSJSONSerialization.dataWithJSONObject(spotzBeacon, options: nil, error: nil)!
                        var spotzBeaconJSON:NSString = NSString(bytes: spotzBeaconData.bytes, length: spotzBeaconData.length, encoding: NSUTF8StringEncoding)!
                        
                        var str:NSString = NSString(format: "hideData(%@,%@,%@)", spotzNameJSON, spotzBeaconJSON, spotzDataJSON)
                        
                        self.webview.stringByEvaluatingJavaScriptFromString(str)
                    }
                    else if let geofence: SpotzGeofence = payload["geofence"] as? SpotzGeofence
                    {
                        // Spotz Geofence to JSON
                        var spotzGeofence = ["latitude":NSNumber(float: geofence.latitude),"longitude":NSNumber(float: geofence.longitude),"radius":NSNumber(float: geofence.radius)]
                        var spotzGeofenceData:NSData = NSJSONSerialization.dataWithJSONObject(spotzGeofence, options: nil, error: nil)!
                        var spotzGeofenceJSON:NSString = NSString(bytes: spotzGeofenceData.bytes, length: spotzGeofenceData.length, encoding: NSUTF8StringEncoding)!
                        
                        var str:NSString = NSString(format: "hideData(%@,%@,%@)", spotzNameJSON, spotzGeofenceJSON, spotzDataJSON)
                        
                        self.webview.stringByEvaluatingJavaScriptFromString(str)
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzRangingNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("Spotz Ranging")
            
            if let data: NSDictionary = note.object as? NSDictionary
            {
                if let spotz = data["spotz"] as? Spotz
                {
                    if let acc = data["accuracy"] as? NSNumber
                    {
                        // Spotz Data to JSON
                        var data:NSDictionary = spotz.data
                        var spotzData:NSData = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: nil)!
                        var spotzDataJSON:NSString = NSString(bytes: spotzData.bytes, length: spotzData.length, encoding: NSUTF8StringEncoding)!
                        
                        // Spotz Name to JSON
                        var spotzName:NSDictionary = ["id":spotz.id,"name":spotz.name]
                        var spotzNameData:NSData = NSJSONSerialization.dataWithJSONObject(spotzName, options: nil, error: nil)!
                        var spotzNameJSON:NSString = NSString(bytes: spotzNameData.bytes, length: spotzNameData.length, encoding: NSUTF8StringEncoding)!
                        
                        // Beacon Accuracy to JSON
                        var beaconAcc = ["acc":NSNumber(float: acc.floatValue)]
                        var beaconAccData:NSData = NSJSONSerialization.dataWithJSONObject(beaconAcc, options: nil, error: nil)!
                        var beaconAccJSON:NSString = NSString(bytes: beaconAccData.bytes, length: beaconAccData.length, encoding: NSUTF8StringEncoding)!
                        
                        var str:NSString = NSString(format: "rangeData(%@,%@,%@)", spotzNameJSON, beaconAccJSON, spotzDataJSON)
                        
                        self.webview.stringByEvaluatingJavaScriptFromString(str)
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzExtensionNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("Spotz Extension")
            
            if let payload = note.object as? NSDictionary
            {
                // Payload String to JSON
                var extensionData:NSData = NSJSONSerialization.dataWithJSONObject(payload, options: nil, error: nil)!
                var extensionJSON:NSString = NSString(bytes: extensionData.bytes, length: extensionData.length, encoding: NSUTF8StringEncoding)!
                
                var str:NSString = NSString(format: "extensionData(%@)", extensionJSON)
                        
                self.webview.stringByEvaluatingJavaScriptFromString(str)
            }
        }
    }
    
    // Actions available to the website
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if (request.URL.scheme == "recheck")
        {
            SpotzSDK.forceCheckSpotz()
            return false
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

