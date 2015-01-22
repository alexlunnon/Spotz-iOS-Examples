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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start with a clean interface
        self.showSpotzDetails(nil)
        self.showBeaconDetails(nil)
        
        // set sdk notifications
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            self.lbStatus.text = "Spotz rocks!"
            
            if note.object != nil
            {
                // the dictionary will contain a spotz object and a beacon object from inside notification
                var data: NSDictionary! = note.object as NSDictionary
                var spotz: Spotz! = data["spotz"] as Spotz
                var beacon: SpotzBeacon! = data["beacon"] as SpotzBeacon
                NSLog("Show spotz details")
                
                NSLog("Enter beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid!,beacon.major,beacon.minor);
                NSLog("Spotz id: %@ name: %@",spotz.id!,spotz.name!);
                
                // show the spotz and beacon data
                self.showSpotzDetails(spotz)
                self.showBeaconDetails(beacon)
            }
            else
            {
                self.showBeaconDetails(nil)
                self.showSpotzDetails(nil)
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            if note.object != nil
            {
                // the dictionary will contain a spotz object and a beacon object from outside notification
                var data: NSDictionary! = note.object as NSDictionary
                var spotz: Spotz! = data["spotz"] as Spotz
                var beacon: SpotzBeacon! = data["beacon"] as SpotzBeacon
                
                // if we have received an outside notification from the current spot, clear the screen (if not, the screen will contain info from another spot which we want to keep there)
                if self.lbBeaconDetails.text == String(format:"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid)
                {
                    self.lbStatus.text = "Find me spotz yo!"
                    self.showBeaconDetails(nil)
                    self.showSpotzDetails(nil)
                }
                
                NSLog("Exit beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid!,beacon.major,beacon.minor);
                NSLog("Spotz id: %@ name: %@",spotz.id!,spotz.name!);
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzRangingNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            // beacon details are not relevant so hide clear them
            self.showBeaconDetails(nil)
            
            if note.object != nil {
                // the dictionary will contain a spotz object and its accuracy
                var data: NSDictionary! = note.object as NSDictionary
                
                var spotz = data["spotz"] as Spotz!
                var acc = data["accuracy"] as NSNumber!
                
                NSLog("Show spotz ranging details")
                
                // show any spotz data
                self.showSpotzDetails(spotz)
                
                // show the accuracy of the spotz
                self.lbBeaconDetails.hidden = false
                self.lbBeaconDetails.text = String(format: "Accuracy: %fm", acc.floatValue)
            }
            else
            {
                self.lbBeaconDetails.hidden = true
            }
        }
    }
    
    func showSpotzDetails(spotz:Spotz!) {
        
        if spotz != nil
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
        
        if beacon != nil
        {
            // show the major, minor, serial and uuid of the beacon
            self.lbBeaconDetails.hidden = false
            self.lbBeaconDetails.text = String(format:"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid)
        }
        else
        {
            // hide the major, minor, serial and uuid of the beacon
            self.lbBeaconDetails.hidden = true
        }
    }
    
    
    // Button actions
    //////
    @IBAction func refreshSpotz() {
        SpotzSDK.checkSpotz()
    }
    
    
    // UITableViewDataSource
    //////
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.spotzData == nil
        {
            return 0
        }
        else
        {
            return self.spotzData?.count as Int!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // fill each cell with a attribute
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("dataCell") as UITableViewCell
        cell.textLabel.text = self.spotzData?.allKeys[indexPath.row] as NSString?
        cell.detailTextLabel?.text = self.spotzData?.allValues[indexPath.row] as NSString?
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

