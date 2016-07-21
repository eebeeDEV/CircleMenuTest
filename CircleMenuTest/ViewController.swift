//
//  ViewController.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 19/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, LMSelectLaiksDelegate {
    
    
    

    let vw = LMSelectLaiks.fromNib()
    
    @IBOutlet weak var imgSelfie: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //let point = self.view.center
        
        vw.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        
        self.view.addSubview(vw)
        

        self.vw.sender = self
        self.vw.delegate = self

        
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

