//
//  Extensions.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 19/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import Foundation
import UIKit
import pop



public extension UIView {
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    
}

public extension UIButton {
    
    
    func animateGlowStart(maxSize: CGFloat, autoReverse: Bool, repeatForever: Bool){
        // check if the glow is already running
        if self.pop_animationForKey("glow") != nil {
            return
        }
        
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        anim.toValue = NSValue(CGSize: CGSizeMake(maxSize, maxSize))
        anim.duration = 1.3
        anim.autoreverses = autoReverse
        anim.repeatForever = repeatForever
        self.layer.pop_addAnimation(anim, forKey: "glow")
    }
    
    func animateGlowStop() {
        self.layer.pop_removeAnimationForKey("glow")
    }
    
    func animateImageTransition(newImageName: String, glow: Bool) {
        
        // check if the glow is already running
        if self.pop_animationForKey("rotate") != nil {
            return
        }
        
        
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            anim.toValue = M_PI * 2
            anim.springSpeed = 3.0
            anim.springBounciness = 8
            
            self.layer.pop_addAnimation(anim, forKey: "rotate")
            self.setImage(UIImage(named: newImageName), forState: .Normal)
            anim.completionBlock = {(animation, finished) in
                if glow == true {
                    self.animateGlowStart(1.1, autoReverse: true, repeatForever: true)
                } else {
                    self.animateGlowStop()
                }
            }
    }
    
    
    func animateImageTransitionShape(newImageName: String, glow: Bool) {
        
        // check if the glow is already running
        if self.pop_animationForKey("shape") != nil {
            return
        }
        
        let image = UIImage(named: newImageName)
        let rect = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerBounds)
        anim.duration = 1.0
        anim.toValue = NSValue(CGRect:rect)

        
        self.layer.pop_addAnimation(anim, forKey: "shape")
        
        anim.completionBlock = {(animation, finished) in
            self.setImage(image, forState: .Normal)
//            if glow == true {
//                self.animateGlowStart(1.1, autoReverse: true, repeatForever: true)
//            } else {
//                self.animateGlowStop()
//            }
        }
    }
    
    

    
}



extension UIColor {
    convenience init(alpha: CGFloat, red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int, alpha: CGFloat) {
        self.init(alpha: alpha, red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}



public extension CGFloat {
    func roundUp(toNearest: CGFloat) -> CGFloat {
        return ceil(self / toNearest) * toNearest
    }
}


func lmCalcSizeFromSixPlusBase(sixPlusSize: CGFloat) -> CGFloat {
    let height = UIScreen.mainScreen().bounds.size.height
    // 736 = height 6+ screen
    let factor: CGFloat = (sixPlusSize / 736)
    return (height * factor).roundUp(2)
}

func lmBtnCornerRadius(sixPlusSize: CGFloat) -> CGFloat {
    return lmCalcSizeFromSixPlusBase(sixPlusSize) / 2
}

