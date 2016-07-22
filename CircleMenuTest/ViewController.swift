//
//  ViewController.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 19/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, LMIconMenuDelegate {
    
    
    

    let vw = LMIconMenu.fromNib()
    
    @IBOutlet weak var imgSelfie: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //let point = self.view.center
        
        var iconColl: LMIconCollection = LMIconCollection()
        
        // uncomment for check totals
//        iconColl.laikIcons = [3,4,7,5,8,9]
//        iconColl.laikColors = [0x3992C3,0x3992C3,0x3992C3,0x3992C3,0x3992C3,0x3992C3]
//        iconColl.laikDescriptions = ["persons like your dress","persons like your eyes","persons like your smile","persons like your hair","persons like the way you talk","persons like the way you move"]
//        iconColl.laikSaved = [false,false,false,false,false,false]
//        self.vw.showTotals = true
        
        // uncomment for give laiks
        iconColl.laikIcons = [3,4,7,5,8,9]
        iconColl.laikColors = [0x3992C3,0x3992C3,0x3992C3,0x3992C3,0x3992C3,0x3992C3]
        iconColl.laikDescriptions = ["","","","","",""]
        iconColl.laikSaved = [false,true,false,false,true,false]
        self.vw.showTotals = false
        
        
        vw.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(vw)
        
        self.vw.iconCollection = iconColl

        self.vw.sender = self
        self.vw.delegate = self
        self.vw.showInfo = false
       
    }
    
    @IBAction func btnShow(sender: AnyObject) {
        
        self.vw.hidden = false
        
    }
    
    func btnBack(sender: UIButton, hasLaikesSelected: Bool) {
        self.vw.hidden = true
    }

    
    
    override func viewDidAppear(animated: Bool) {
        

        
        
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

