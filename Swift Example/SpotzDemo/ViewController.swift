//
//  ViewController.swift
//  SpotzDemo
//
//  Created by Daniel Sykes-Turner on 13/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblBeaconInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set up to recieve notifications from a spot
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("----------\ninside!")
            if note.object != nil {
                self.spotzInside(note.object as NSDictionary)
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(SpotzOutsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
            NSLog("----------\noutside!")
            if note.object != nil {
                self.spotzOutside(note.object as NSDictionary)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshSpotz() {
        SpotzSDK.checkSpotz()
    }
    
    func spotzInside(data:NSDictionary) {
        
        // spotz and spotz beacon won't always both be returned
        var spotz = data["spotz"] as Spotz!
        var beacon = data["beacon"] as SpotzBeacon!
        
        self.lblBeaconInfo.text = String(format: "UUID: %@\nMajor: %i\nMinor: %i", beacon.uuid,beacon.major,beacon.minor)
        NSLog("Beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor)
        // Do something amazing here
    }
    
    func spotzOutside(data:NSDictionary) {
        
        // spotz and spotz beacon won't always both be returned
        var spotz = data["spotz"] as Spotz!
        var beacon = data["beacon"] as SpotzBeacon!
        
        NSLog("Beacon left with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor)
        // Remove from any arrays/containers
    }

}

