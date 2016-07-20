//
//  LMConstraint.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 09/07/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//


import UIKit
import pop


class LMPopYConstraint: NSLayoutConstraint {
    
    class var offScreenTopPosition: CGPoint{
        return CGPointMake(0, -UIScreen.mainScreen().bounds.height)
    }

    
    class var offScreenBottomPosition: CGPoint{
        return CGPointMake(0, UIScreen.mainScreen().bounds.height)
    }
    
    class var screenNormalPosition: CGPoint{
        return CGPointMake(0, 0)
    }
    
    var origValue = CGFloat()
    var isTop: Bool = false
    
    func hideViewTop() {
        origValue = self.constant
        self.constant = LMPopYConstraint.offScreenTopPosition.y
        self.isTop = true
    }

    
    func hideViewBottom() {
        origValue = self.constant
        self.constant = LMPopYConstraint.offScreenBottomPosition.y
        self.isTop = false
    }
    
    func animateShow(delay: CFTimeInterval = 0){
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        moveAnim.toValue = self.origValue
        moveAnim.springBounciness = 5
        moveAnim.springSpeed = 5
        moveAnim.beginTime = CACurrentMediaTime() + delay
        self.pop_addAnimation(moveAnim, forKey: "show")
        moveAnim.completionBlock = {(animation, finished) in
            // do something
        }
    }
    
    
    func animateHide(delay: CFTimeInterval = 0){
        let moveAnim = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        if self.isTop == true {
            moveAnim.toValue = LMPopYConstraint.offScreenTopPosition.y
        } else {
            moveAnim.toValue = LMPopYConstraint.offScreenBottomPosition.y
        }
        moveAnim.beginTime = CACurrentMediaTime() + delay
        self.pop_addAnimation(moveAnim, forKey: "hide")
        moveAnim.completionBlock = {(animation, finished) in
            // do something
        }
    }
}


class LMPopXConstraint: NSLayoutConstraint {
    
    class var offScreenRightPosition: CGPoint{
        return CGPointMake(UIScreen.mainScreen().bounds.width, 0)
    }
    
    class var offScreenLeftPosition: CGPoint{
        return CGPointMake(-UIScreen.mainScreen().bounds.width, 0)
    }

    
    class var screenNormalPosition: CGPoint{
        return CGPointMake(0, 0)
    }
    
    var origValue = CGFloat()
    var isLeft: Bool = false
    
    func hideViewRight() {
        origValue = self.constant
        self.constant = LMPopXConstraint.offScreenRightPosition.x
        self.isLeft = false
    }
    
    func hideViewLeft() {
        origValue = self.constant
        self.constant = LMPopXConstraint.offScreenLeftPosition.x
        self.isLeft = true
    }
    
    func animateShow(delay: CFTimeInterval = 0){
        if self.pop_animationForKey("show") != nil || self.pop_animationForKey("hide") != nil {
            return
        }
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        moveAnim.toValue = self.origValue
        moveAnim.springBounciness = 18
        moveAnim.springSpeed = 18
        moveAnim.beginTime = CACurrentMediaTime() + delay
        self.pop_addAnimation(moveAnim, forKey: "show")
        moveAnim.completionBlock = {(animation, finished) in
            // do something
        }
    }
    
    
    func animateHide(delay: CFTimeInterval = 0){
        if self.pop_animationForKey("show") != nil || self.pop_animationForKey("hide") != nil {
            return
        }
        
        let moveAnim = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        if self.isLeft == true {
            moveAnim.toValue = LMPopXConstraint.offScreenLeftPosition.x
        } else {
            moveAnim.toValue = LMPopXConstraint.offScreenRightPosition.x
        }
        moveAnim.duration = 0.2
        moveAnim.beginTime = CACurrentMediaTime() + delay
        self.pop_addAnimation(moveAnim, forKey: "hide")
        moveAnim.completionBlock = {(animation, finished) in
                // do something
        }
    }
    

}