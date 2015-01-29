//
//  ViewController.swift
//  SpotzDemo
//
//  Created by Daniel Sykes-Turner on 13/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbSpotzName: UILabel!
    @IBOutlet weak var lbBeaconDetails: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var spotzData: NSDictionary?
    var currentBeaconSerial: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start with a clean screen

        self.showSpotzDetails(nil)
        self.showBeaconDetails(nil)
        
        // Set up our Notification Observers
        
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let data = note.object as? NSDictionary
            {
                // Take out the Spotz object and its beacon
                let spotz = data["spotz"] as Spotz!
                let beacon = data["beacon"] as SpotzBeacon!
                
                self.lbStatus.text = "Spotz rocks!"
                self.showSpotzDetails(spotz)
                self.showBeaconDetails(beacon)
                        
                NSLog("Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if let data = note.object as? NSDictionary
            {
                // Take out the Spotz object and its beacon
                let spotz = data["spotz"] as Spotz!
                let beacon = data["beacon"] as SpotzBeacon!
             
                // Remove the current spot from the screen if it is the last found as well
                if (beacon.serial == self.currentBeaconSerial)
                {
                    self.lbStatus.text = "Find me spotz yo!"
                    self.showBeaconDetails(nil)
                    self.showSpotzDetails(nil)
                }
                
                NSLog("Exit beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
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
                self.lbBeaconDetails.hidden = false
                self.lbBeaconDetails.text = NSString(format: "Accuracy: %fm", acc.floatValue)
                
                self.showSpotzDetails(spotz)
                
                NSLog("Spotz %@ accuracy %@", spotz.name, acc);
            }
        }
    }
    
    func showSpotzDetails(spotz:Spotz!) {
        
        if (spotz != nil)
        {
            // show the spotz name and any attributes
            self.lbSpotzName.hidden = false
            self.tableView.hidden = false
            self.lbSpotzName.text = spotz.name
            
            self.spotzData = spotz.data
            self.tableView.reloadData()
        }
        else
        {
            // hide the spotz name and any attributes
            self.lbSpotzName.hidden = true
            self.tableView.hidden = true
            self.spotzData = [:]
        }
    }
    
    func showBeaconDetails(beacon:SpotzBeacon!) {

        if (beacon != nil)
        {
            // show the major, minor, serial and uuid of the beacon
            self.lbBeaconDetails.hidden = false
            self.lbBeaconDetails.text = String(format:"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid)
            
            self.currentBeaconSerial = beacon.serial
        }
        else
        {
            // hide the major, minor, serial and uuid of the beacon
            self.lbBeaconDetails.hidden = true
            
            self.currentBeaconSerial = nil
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

