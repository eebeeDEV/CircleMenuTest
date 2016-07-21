//
//  LMBtnLike.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 20/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//


import UIKit

import pop





protocol LMBtnLikeDelegate {
    func btnSelectionChanged(sender: LMBtnLike, isSelected: Bool)
}



class LMBtnLike: UIButton {
    
    let lblTotal = UILabel()
    var laiksTotal : Int = 0
    var index: Int!
    var btnCenter: CGPoint!
    var btnCirclePoint: CGPoint!
    var btnCircleOffScreenPoint: CGPoint!
    var btnColor: Int!
    
    var x: CGFloat!
    var y: CGFloat!
    var selectedImage: String!
//    var unSelectedImage: String!
    var likeDescr: String!
    var showTotals = false
    var anim = AnimationEngine()
    
    
    
    var delegate: LMBtnLikeDelegate?
    
    
    var isTapped: Bool = false {
        didSet{            
            if isTapped == true {
                self.setImage(UIImage(named: selectedImage!), forState: .Normal)
                anim.animateBackgroundColorLayer(self.layer, backColor: 0x3992C3, alpha: 1)
                self.layer.borderColor = UIColor(alpha: 0.2, red: 255, green: 255, blue: 255).CGColor
                
            } else {
                self.setImage(UIImage(named: selectedImage!), forState: .Normal)
                anim.animateBackgroundColorLayer(self.layer, backColor: 0xE4E4E4, alpha: 1)
                self.layer.borderColor = UIColor(alpha: 0.2, red: 0, green: 0, blue: 0).CGColor
            }
        }
    }
    
    var isSaved: Bool = false {
        didSet{
            if isSaved == true {
                self.setImage(UIImage(named: selectedImage!), forState: .Normal)
                anim.animateBackgroundColorLayer(self.layer, backColor: 0x29516D, alpha: 1)
                self.layer.borderColor = UIColor(alpha: 1, red: 41, green: 81, blue: 109).CGColor
            } else {
                self.setImage(UIImage(named: selectedImage!), forState: .Normal)
                anim.animateBackgroundColorLayer(self.layer, backColor: 0xE4E4E4, alpha: 1)
                self.layer.borderColor = UIColor(alpha: 0.2, red: 0, green: 0, blue: 0).CGColor
            }
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
            self.selectedImage = "Like\(imageIndex)"            
        }
        
        
        self.layer.borderColor = UIColor(alpha: 0.5, red: 0, green: 0, blue: 0).CGColor
        self.layer.borderWidth = 1
        
        self.showTotals = showTotals
        self.isTapped = false
        
        if showTotals == true {
            setLabel(laiksTotal)
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
    
    func btnClicked(sender: LMBtnLike){
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
