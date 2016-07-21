//
//  AnimationEngine.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 07/07/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import UIKit
import pop


class AnimationEngine {
  
    var icons: [LMBtnLike]!

    
    func loadButtonsInMemory(icons: [LMBtnLike]){
        self.icons = icons
    }
    

    func animateBackgroundColorView(view: UIView, backColor: Int, alpha: CGFloat){
        
        let colorAnim = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        colorAnim.toValue = UIColor(netHex: backColor, alpha: alpha)
        colorAnim.duration = 0.5
        view.pop_addAnimation(colorAnim, forKey: "changeColor")
    }
    func animateBackgroundColorLayer(layer: CALayer, backColor: Int, alpha: CGFloat){
        
        let colorAnim = POPBasicAnimation(propertyNamed: kPOPLayerBackgroundColor)
        colorAnim.toValue = UIColor(netHex: backColor, alpha: alpha)
        colorAnim.duration = 0.5
        layer.pop_addAnimation(colorAnim, forKey: "changeColor")
    }
    
    func animateHide(view: UIView, duration: CFTimeInterval = 0.5, delay: CFTimeInterval = 0, completion:((finished: Bool) -> Void)?) {
        
        if view.pop_animationForKey("hide") != nil {
            return
        }
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.toValue = 0
        anim.duration = duration
        anim.beginTime = CACurrentMediaTime() + delay
        view.pop_addAnimation(anim, forKey: "hide")        
        anim.completionBlock = {(animation, finished) in
            print("finished animateHide")
        }
    }
    
    
    func animateShow(view: UIView, duration: CFTimeInterval = 0.5, delay: CFTimeInterval = 0, completion:(() -> Void)?) {
        
        if view.pop_animationForKey("show") != nil {
            view.pop_removeAllAnimations()
        }
        
        view.alpha = 0
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.toValue = 1
        anim.duration = duration
        anim.beginTime = CACurrentMediaTime() + delay
        view.pop_addAnimation(anim, forKey: "show")
        anim.completionBlock = {(animation, finished) in
            print("finished animateShow")
        }
    }
    
    

    
    
    func animateButtonsDistribution(inSequence: Bool){
        
        if self.icons != nil {
            // check if an animation is going on
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                if btn.pop_animationForKey("alpha") != nil || btn.pop_animationForKey("move") != nil {
                    btn.pop_removeAllAnimations()
                }
            }
            
            
            // set the start position
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                btn.alpha = 0
                btn.center = btn.btnCenter
            }
            
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                alphaAnim.toValue = 1.0
                alphaAnim.duration = 0.3
                if inSequence == true {
                    alphaAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
                }
                btn.pop_addAnimation(alphaAnim, forKey: "alpha")
                alphaAnim.completionBlock = {(animation, finished) in
                    print("distribution alpha")
                }
                
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 20
                moveAnim.toValue = NSValue(CGPoint: btn.btnCirclePoint)
                if inSequence == true {
                    moveAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
                }
                btn.pop_addAnimation(moveAnim, forKey: "move")
                moveAnim.completionBlock = {(animation, finished) in
                    print("distribution move")
                }
            }
        }
    }
    
    
    func animateButtonsDistributionAlpha(inSequence: Bool){
        if self.icons != nil {
            // check if an animation is going on
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                if btn.pop_animationForKey("alpha") != nil || btn.pop_animationForKey("move") != nil {
                    btn.pop_removeAllAnimations()
                }
            }
            
            // set the inistial position
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                btn.alpha = 0
                btn.center = btn.btnCirclePoint
            }
            
            var duration: CFTimeInterval = 0
            
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                alphaAnim.toValue = 1.0
                
                if inSequence == true {
                    alphaAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.1
                    duration = 0.3
                } else {
                    duration = 0.8
                }
                alphaAnim.duration = duration
                btn.pop_addAnimation(alphaAnim, forKey: "alpha")
            }
        }
    }
    
    ///This animation moves all buttons back the the center and set their alpha value to 0
    func animateButtonsToCenter(inSequence: Bool){
        
        if self.icons != nil {
            // check if an animation is going on
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                if btn.pop_animationForKey("alpha") != nil || btn.pop_animationForKey("move") != nil {
                    btn.pop_removeAllAnimations()
                }
            }
            
            for i in (0..<self.icons.count) {
                let btn = self.icons[i]
                
                let moveAnim = POPBasicAnimation(propertyNamed: kPOPViewCenter)
                moveAnim.toValue = NSValue(CGPoint: btn.btnCenter)
                moveAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
                btn.pop_addAnimation(moveAnim, forKey: "toCenter")
                moveAnim.completionBlock = {(animation, finished) in
                    print("center move")
                }
                
                let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                alphaAnim.toValue = 0
                alphaAnim.duration = 0.15
                if inSequence == true {
                    alphaAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
                }
                btn.pop_addAnimation(alphaAnim, forKey: "alpha")
                alphaAnim.completionBlock = {(animation, finished) in
                    print("center alpha")
                }
            }

        }
    }
    
    func animateButtonsOffScreen(inSequence: Bool){
        
        // check if an animation is going on
        for i in (0..<self.icons.count) {
            let btn = self.icons[i]
            if btn.pop_animationForKey("alpha") != nil || btn.pop_animationForKey("move") != nil {
                return
            }
        }
        
        for i in (0..<self.icons.count) {
            let btn = self.icons[i]
            btn.pop_removeAllAnimations()
            let moveAnim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            moveAnim.springBounciness = 6
            moveAnim.springSpeed = 2
            moveAnim.toValue = NSValue(CGPoint: btn.btnCircleOffScreenPoint)
            if inSequence == true {
                moveAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
            }
            
            btn.pop_addAnimation(moveAnim, forKey: "move")
            moveAnim.completionBlock = {(animation, finished) in
                print("offscreen move")
            }
            
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0
            
            alphaAnim.duration = 0.15
            if inSequence == true {
                alphaAnim.beginTime = CACurrentMediaTime() + Double(i) * 0.05
            }
            btn.pop_addAnimation(alphaAnim, forKey: "alpha")
            alphaAnim.completionBlock = {(animation, finished) in
                print("offscreen alpha")
            }
            
//            alphaAnim.completionBlock = {(animation, finished) in
//                if finished == true {
//                    print ("center")
//                    btn.center = btn.btnCenter
//                }
//            }
        }
    }
    
    
    
    
   


}
