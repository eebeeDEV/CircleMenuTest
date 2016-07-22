//
//  LMBtnLike.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 20/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//


import UIKit

import pop





protocol LMIconBtnDelegate {
    func btnSelectionChanged(sender: LMIconBtn, isSelected: Bool)
}



class LMIconBtn: UIButton {
    
    let lblTotal = UILabel()
    var laiksTotal : Int = 0
    var index: Int!
    var btnCenter: CGPoint!
    var btnCirclePoint: CGPoint!
    var btnCircleOffScreenPoint: CGPoint!
    var btnColor: Int!
    
    var x: CGFloat!
    var y: CGFloat!
    var iconImage: String!

    var likeDescr: String!
    var showTotals = false
    var anim = AnimationEngine()
    
    
    
    var delegate: LMIconBtnDelegate?
    
    
    var isTapped: Bool = false {
        didSet{
            self.setIconColor()
        }
    }
    
    var isSaved: Bool = false {
        didSet{
            self.setIconColor()
        }
    }
 
    
    init(frame: CGRect, imageIndex: Int, laiksTotal: Int, showTotals: Bool) {
        
        if showTotals ==  true {
            self.laiksTotal = laiksTotal
            var btnFrame: CGRect!
            let factor: CGFloat = 1.16666666666666666667
            btnFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * factor, frame.size.height * factor)
            super.init(frame: btnFrame)
            self.layer.cornerRadius = btnFrame.height / 2
            setLabel(laiksTotal)
        } else {
            super.init(frame: frame)
            self.layer.cornerRadius = frame.height / 2
        }
        
        self.iconImage = "Like\(imageIndex)"
        self.setImage(UIImage(named: self.iconImage!), forState: .Normal)
        
        self.layer.borderColor = UIColor(alpha: 0.5, red: 0, green: 0, blue: 0).CGColor
        self.layer.borderWidth = 1
        
        self.showTotals = showTotals
        self.isTapped = showTotals
        self.setIconColor()
    }
    
 

    func setIconColor(){
        
        if self.isSaved == true {
            anim.animateBackgroundColorLayer(self.layer, backColor: 0x29516D, alpha: 1)
            self.layer.borderColor = UIColor(netHex: 0x29516D, alpha: 1).CGColor
        } else if self.isTapped == true {
            anim.animateBackgroundColorLayer(self.layer, backColor: 0x3992C3, alpha: 1)
            self.layer.borderColor = UIColor(netHex: 0x3992C3, alpha: 1).CGColor
        } else {
            anim.animateBackgroundColorLayer(self.layer, backColor: 0xE4E4E4, alpha: 1)
            self.layer.borderColor = UIColor(netHex: 0x3992C3, alpha: 1).CGColor
        }
        

        
        
    }
    
    
    
    
    
    func setupTargets(){
        
        if self.isSaved == false {
            self.addTarget(self, action: #selector(btnClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
//            self.addTarget(self, action: #selector(scaleToSmall), forControlEvents: UIControlEvents.TouchDown)
//            self.addTarget(self, action: #selector(scaleToSmall), forControlEvents: UIControlEvents.TouchDragEnter)
//            self.addTarget(self, action: #selector(scaleAnimation), forControlEvents: UIControlEvents.TouchUpInside)
//            self.addTarget(self, action: #selector(scaleDefault), forControlEvents: UIControlEvents.TouchDragExit)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setLabel(total:Int){
        
        let width: CGFloat = 21.0
        let height: CGFloat = 21.0
        let x = self.frame.width - width - 8
        let y: CGFloat = 5
        
        
        self.lblTotal.text = "\(total)"
        self.lblTotal.frame = CGRectMake(x , y, width, height)
        self.lblTotal.font = UIFont(name: "AvenirNext-Bold", size: 12)
        self.lblTotal.textAlignment = NSTextAlignment.Center
        self.lblTotal.alpha = 0.6
        self.addSubview(lblTotal)
        
    }
    
    func btnClicked(sender: LMIconBtn){
        if (sender == self){
            if self.showTotals == false {
                self.isTapped = !self.isTapped
            }
            
            if let delegate = self.delegate {
                delegate.btnSelectionChanged(sender, isSelected: self.isTapped)
            }
        }
    }

    func scaleToSmall(){
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSmallAnim")
    }
    func scaleAnimation(){
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnim")
    }
    func scaleDefault(){
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleDefaultAnim")
    }
    
    

}
