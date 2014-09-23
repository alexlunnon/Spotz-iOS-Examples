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
    @IBOutlet weak var tableView: UITableView!
    var spotzData: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set up to recieve notifications from a spot
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            self.lbStatus.text = "Spotz rocks!"
            
            if note.object != nil
            {
                var data: NSDictionary! = note.object as NSDictionary
                var spotz: Spotz! = data["spotz"] as Spotz
                var beacon: SpotzBeacon! = data["beacon"] as SpotzBeacon
                NSLog("Show spotz details")
                
                NSLog("Enter beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid!,beacon.major,beacon.minor);
                NSLog("Spotz id: %@ name: %@",spotz.id!,spotz.name!);
                
                self.showSpotzDetails(spotz)
            }
            else
            {
                self.showSpotzDetails(nil)
            }
            
            self.tableView.reloadData()
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            
            self.lbStatus.text = "Find me spotz yo!"
            self.showSpotzDetails(nil)
            if note.object != nil
            {
                var data: NSDictionary! = note.object as NSDictionary
                var spotz: Spotz! = data["spotz"] as Spotz
                var beacon: SpotzBeacon! = data["beacon"] as SpotzBeacon
                
                NSLog("Exit beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid!,beacon.major,beacon.minor);
                NSLog("Spotz id: %@ name: %@",spotz.id!,spotz.name!);
            }
        }
    }
    
    func showSpotzDetails(spotz:Spotz!) {
        
        if spotz != nil
        {
            self.lbSpotzName.hidden = false
            self.tableView.hidden = false
            self.lbSpotzName.text = spotz.name
            
            if spotz.data.count > 0
            {
                self.spotzData = spotz.data
            }
        }
        else
        {
            self.lbSpotzName.hidden = true
            self.tableView.hidden = true
            self.spotzData = []
        }
    }
    
    
    // Button actions
    
    @IBAction func refreshSpotz() {
        SpotzSDK.checkSpotz()
    }
    
    
    // UITableViewDataSource
    
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
        
        var data:NSDictionary! = self.spotzData?.objectAtIndex(indexPath.row) as NSDictionary!
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("dataCell") as UITableViewCell
        cell.textLabel?.text = data["key"] as String?
        cell.detailTextLabel?.text = data["value"] as String?
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

