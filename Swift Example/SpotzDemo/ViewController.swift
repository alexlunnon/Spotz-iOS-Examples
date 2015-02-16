//
//  ViewController.swift
//  SpotzDemo
//
//  Created by Daniel Sykes-Turner on 13/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

// Things to remember
// ------------------
//
// You cannot monitor for more than 20 regions
//  (20 regions = total beacons + total geofences) 
//  per app.
// There is also a device limit which you are
//  not told about. On smaller devices (e.g.
//  iPod touch) this is 20 regions. On larger
//  devices (e.g. iPhone 6) this is 30 regions.
// BUT we use magic to avoid these limits, so
//  there may be a delay between swapping
//  inbetween Spotz groups if you don't use
//  SpotzSDK.forceCheckSpotz().
//
// Geofences are not as accurate as beacons,
//  AT BEST they have an accuracy of 5 meters.
// So it is very possible that a devices can
//  physically cross a geofences area but not
//  be picked up because the device still thinks
//  it is outside due to the low accuracy. Walking
//  around a little may help.
//
// That is all :)

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbSpotzName: UILabel!
    @IBOutlet weak var lbDetails: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var foundSpotz: NSMutableDictionary! = NSMutableDictionary() // all the spotz we have seen
    var insideRegions: NSMutableArray! = NSMutableArray() // all the regions we are currently inside (can be more than 1 beacon per spot)
    var spotzData: NSDictionary? // the attributes of the current spot

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start with a clean screen
        self.updateView()
        
        // Set up our Notification Observers
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let data = note.object as? NSDictionary
            {
                // Take out the Spotz object and its beacon
                if let spotz = data["spotz"] as? Spotz
                {
                    // Entry region will be either a geofence or a beacon
                    if let beacon = data["beacon"] as? SpotzBeacon
                    {
                        self.addRegion(spotz, beacon: beacon, geofence: nil)
                        NSLog("Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
                    }
                    
                    if let geofence = data["geofence"] as? SpotzGeofence
                    {
                        self.addRegion(spotz, beacon: nil, geofence: geofence)
                        NSLog("Entry geofence (%@) detected with latitude: %f longitude: %f radius %i",spotz.name,geofence.latitude,geofence.longitude,Int(geofence.radius));
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let data = note.object as? NSDictionary
            {
                // Take out the Spotz object and its beacon or geofence
                if let spotz = data["spotz"] as? Spotz
                {
                    // Remove the current spot from the screen if it is the last found as well
                    if let beacon = data["beacon"] as? SpotzBeacon
                    {
                        self.removeRegions(beacon, geofence: nil)
                        NSLog("Exit beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
                    }
                    
                    if let geofence = data["geofence"] as? SpotzGeofence
                    {
                        self.removeRegions(nil, geofence: geofence)
                        NSLog("Exit geofence (%@) detected with latitude: %f longitude: %f radius %i",spotz.name,geofence.latitude,geofence.longitude, Int(geofence.radius));
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzRangingNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let data = note.object as? NSDictionary
            {
                // Take out the Spotz object and the distance
                // Also available is the rssi and the CLBeacon
                let spotz = data["spotz"] as Spotz!
                let acc = data["accuracy"] as NSNumber!
                
                // Show the accuracy of the spotz
                self.lbDetails.text = NSString(format: "Accuracy: %fm", acc.floatValue)
                self.lbSpotzName.text = spotz.name
                if (self.spotzData != spotz.data)
                {
                    self.spotzData = spotz.data
                    self.tableView.reloadData()
                }
                
                NSLog("Spotz %@ accuracy %@", spotz.name, acc);
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzExtensionNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let payload = note.object as? NSDictionary
            {
                 //handle our extension data
//                if let httpGetWebhook = payload["httpGetWebhook"] as? NSDictionary
//                {
//                    println("httpGetWebhook: \(httpGetWebhook)")
//                    // do something here
//                }
//                if let teradataARTIM = payload["teradataARTIM"] as? NSDictionary
//                {
//                    println("teradataARTIM: \(teradataARTIM)")
//                    // do something here
//                }
                if let spotz = payload["spotz"] as? Spotz
                {
                    println("Extension for Spotz: \(spotz.name)")
                }
            }
        }
    }
    
    func addRegion(spotz:Spotz!, beacon:SpotzBeacon!, geofence:SpotzGeofence!) {
        
        // add or update the known spotz
        self.foundSpotz?.setObject(spotz, forKey: spotz.id)
        
        // add to our currently inside regions
        if (beacon != nil)
        {
            self.insideRegions?.insertObject(beacon, atIndex: 0)
        }
        if (geofence != nil)
        {
            self.insideRegions?.insertObject(geofence, atIndex: 0)
        }
        
        self.updateView()
    }
    
    func removeRegions(beacon:SpotzBeacon?, geofence:SpotzGeofence?) {
        
        var newArray:NSMutableArray = NSMutableArray()
        
        // create a new array with all the same regions excluding the beacons and geofences passed in
        for var i = 0; i < self.insideRegions?.count; i++
        {
            if let b = self.insideRegions?[i] as? SpotzBeacon
            {
                // we can use serial here because every beacon has a different serial
                if (beacon?.serial != nil && beacon?.serial != b.serial)
                {
                    newArray.addObject(b)
                }
            }
            else if let g = self.insideRegions?[i] as? SpotzGeofence
            {
                // we can use spotzId here because each spot can ONLY have one geofence at most
                if (geofence?.spotzId != nil && geofence?.spotzId != g.spotzId)
                {
                    newArray.addObject(g)
                }
            }
            else
            {
                // something odd has been passed in or nothing. don't update
                return
            }
        }
        
        self.insideRegions = newArray
        self.updateView()
    }
    
    func updateView()
    {
        // if were are currently inside a region. otherwise clear the screen.
        if (self.insideRegions?.count > 0)
        {
            // check whether the last inside region object was a beacon or a geofence.
            // the list is sorted by order seen, so the first object will be last seen.
            if let beacon = self.insideRegions?.firstObject as? SpotzBeacon
            {
                var spotz:Spotz = self.foundSpotz?.objectForKey(beacon.spotzId) as Spotz!
                self.spotzData = spotz.data
                
                self.lbSpotzName.text = spotz.name
                self.lbStatus.text = "Spotz rocks!"
                self.lbDetails.text = "major:\(beacon.major) minor:\(beacon.minor) serial(\(beacon.serial))\n\(beacon.uuid)"
                self.tableView.reloadData()
            }
            else if let geofence = self.insideRegions?.firstObject as? SpotzGeofence
            {
                var spotz:Spotz = self.foundSpotz?.objectForKey(geofence.spotzId) as Spotz!
                self.spotzData = spotz.data
                
                self.lbSpotzName.text = spotz.name
                self.lbStatus.text = "Spotz rocks!"
                self.lbDetails.text = NSString(format: "%f, %f\nradius: %i", geofence.latitude, geofence.longitude, Int(geofence.radius))
                self.tableView.reloadData()
            }
        }
        else
        {
            // clear the screen
            self.lbSpotzName.text = ""
            self.lbStatus.text = ""
            self.lbDetails.text = ""
            self.spotzData = nil
            self.tableView.reloadData()
        }
    }
    
    // Button actions
    //////
    @IBAction func refreshSpotz() {
        
        SpotzSDK.forceCheckSpotz()
    }
    
    
    // UITableViewDataSource
    //////
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let dataCount = self.spotzData?.count
        {
            return dataCount
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // fill each cell with a attribute
        var cell = tableView.dequeueReusableCellWithIdentifier("dataCell") as UITableViewCell
        cell.textLabel?.text = self.spotzData?.allKeys[indexPath.row] as NSString
        cell.detailTextLabel?.text = self.spotzData?.allValues[indexPath.row] as NSString
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

