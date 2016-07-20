//
//  LMSelectLaiks.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 19/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import UIKit

class LMSelectLaiks: UIView, LMBtnLikeDelegate {
    
  
    
    var laikIcons = [3,4,7,5,8,9]
    let laikColors = [0x50E3C2,0xB8E986,0x4A90E2,0x8B572A,0x4A90E2,0x9B9B9B]
    let laikDescriptions = ["persons like your dress","persons like your eyes","persons like your smile","persons like your hair","persons like the way you talk","persons like the way you move"]
    let laikSaved = [false,true,false,false,true,false]
    var laikLastIconClicked: Int = -1
    var btnIcons = [LMBtnLike]()
    var sender: UIViewController!
    var btnSelectedCount: Int = 0
    var showInfo = true
    var showTotals = false

    
    var menuStatus: enumStatus = enumStatus.menuLoaded {
        didSet{
            switch self.menuStatus {
            case enumStatus.menuLoaded:
                break
            case enumStatus.iconsCreated:
                self.showButtons()
                break
            case enumStatus.iconsVisible:
                if self.btnSelectedCount > 0 {
                    self.btnMain.animateImageTransitionShape("LikeSave", glow: true)
                } else {
                    self.btnMain.animateImageTransitionShape("LikeStarOrange", glow: false)
                }
                break
            case enumStatus.iconsHidden:
                break
            case enumStatus.iconsSelected:
                self.btnMain.animateImageTransitionShape("LikeSave", glow: true)
                break
            case enumStatus.iconsDeselected:
                self.btnMain.animateImageTransitionShape("LikeStarOrange", glow: false)
                break
            case enumStatus.likesSaved:
                self.btnMain.animateImageTransitionShape("LikeStarOrange", glow: false)
                break
            }
        }
    }
    
    var animEngine: AnimationEngine!
    
    
    enum enumStatus {
        case menuLoaded
        case iconsCreated
        case iconsVisible
        case iconsHidden
        case iconsSelected
        case iconsDeselected
        case likesSaved
    }
    
    
    
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var btnMain: UIButton!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var vwLikeDescr: UIView!
    @IBOutlet weak var lblLikeDescr: UILabel!
    @IBOutlet weak var segSendReceive: UISegmentedControl!
  
    
    @IBOutlet weak var vwLaikDescrLeftConstraint: LMPopXConstraint!
    
    
    
    @IBAction func btnHide(sender: AnyObject) {
        self.animEngine.animateHide(self.vwInfo, duration: 1, delay: 0, completion: nil)
        
    }

    

    
    @IBAction func btnMain(sender: AnyObject) {
        
        switch self.menuStatus {
        case enumStatus.menuLoaded:
            self.createIcons()
            break
        case enumStatus.iconsCreated:
            showButtons()
            break
        case enumStatus.iconsHidden:
            showButtons()
            break
        case enumStatus.iconsVisible:
            hideButtons()
            break
        case enumStatus.likesSaved:
            // save the likes here
            self.btnMain.animateGlowStop()
            self.btnMain.animateImageTransitionShape("LikeStarOrange", glow: false)
            hideButtons()
            break
        default:
            hideButtons()
            break
        }

    }
  
    

    
    override func awakeFromNib() {
        
        self.addGesture()
        self.vwBackground.layer.cornerRadius = 4
        self.btnMain.alpha = 0
        self.animEngine = AnimationEngine()
        // show the main button with a 3sec delay
        self.animEngine.animateShow(self.btnMain, duration: 0.8, delay: 3, completion: nil)
        // hide the liaksdescription view
        self.vwLaikDescrLeftConstraint.hideViewRight()
        self.segSendReceive.selectedSegmentIndex = 0
        
        // sow / hide the info text how to use the control
        if self.showInfo == false {
            self.vwInfo.hidden = true
        }
    }
    

    
    @IBAction func segSendReceiveTapped(sender: UISegmentedControl) {
        
//        self.btnMain.pop_removeAllAnimations()
//        self.hideButtons()
//        self.resetButtons()
//        
//        if segSendReceive.selectedSegmentIndex == 0 {
//            self.showTotals = false
//        } else {
//            self.showTotals = true
//        }
//        
//        self.animEngine.animateShow(self.btnMain, duration: 0.3, delay: 0, completion: nil)
//        self.createIcons()
//        viewDidLoad = false
        
        
    }
    
    
    
    
    
    func createIcons(){
        

            
            
            print("creating icons")
            
            // clear the array first
            btnIcons.removeAll()
            
            var angle: CGFloat = 0.0
            let increm: CGFloat = 360.0 / CGFloat(self.laikIcons.count)
            let radius = Float(lmCalcSizeFromSixPlusBase(100))
            let radiusOffScreen = Float(UIScreen.mainScreen().bounds.size.height)
            let centralPoint = self.btnMain.center
            
            
            
            
            for i in (0..<self.laikIcons.count) {
                let c = self.laikIcons[i]
                let btn: LMBtnLike = LMBtnLike(frame: self.btnMain.frame, imageIndex: c, laiksTotal: c, showTotals: self.showTotals)
                
                // set the description, index, color ans status
                btn.likeDescr = "\(c) \(laikDescriptions[i])"
                btn.index = i
                btn.btnColor = self.laikColors[i]
                btn.isTapped = false
                // set the points to move the icon to
                btn.btnCirclePoint = self.specificPointOnCircle(radius, center: centralPoint, angle: angle)
                btn.btnCircleOffScreenPoint = self.specificPointOnCircle(radiusOffScreen, center: centralPoint, angle: angle)
                btn.center = centralPoint
                btn.btnCenter = centralPoint
                angle = angle + increm
                // set the delegate
                btn.delegate = self
                // if selected, add it to the btnSelectedCount
                //self.btnSelectedCount = self.btnSelectedCount + Int(self.laikSaved[i])
                // hide the iscon
                btn.alpha = 0
                btn.isSaved = self.laikSaved[i]
                btn.setupTargets()
                // add it to the view
                self.vwButtons.addSubview(btn)
                // add it to the btnIcons array
                btnIcons.append(btn)
                self.bringSubviewToFront(btn)
            }
            

            // load the icons in the animation engine memory
            self.animEngine.loadButtonsInMemory(self.btnIcons)
            self.bringSubviewToFront(self.btnMain)
        
            // set the status at the end of the proc!!
            self.menuStatus = enumStatus.iconsCreated
        

        
        
        
    }
    
    
    
    
    func resetButtons(){
        
        self.btnIcons.removeAll()
        
        
    }
    
    
    
    func addGesture(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(selfieTapped))
        self.userInteractionEnabled = true
        self.vwMain.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    func selfieTapped(){
        
        
        switch self.menuStatus {
        case enumStatus.menuLoaded:
            self.animEngine.animateShow(self.btnMain, duration: 0, delay: 0, completion: nil)
                self.createIcons()
            break
        case enumStatus.iconsCreated:
            self.showButtons()
            break
        case enumStatus.iconsHidden:
            self.showButtons()
            break
        default:
            self.hideButtons()
            break
        }
    
    
    }
    
    func showButtons(){
        
        
        self.animEngine.animateShow(self.btnMain, completion: nil)
        self.animEngine.animateButtonsDistribution(false)
        
        // set the status at the end of the proc!!
        self.menuStatus = enumStatus.iconsVisible
        
    }
    

    
    func hideButtons() {
        
        self.animEngine.animateButtonsOffScreen(false)
        // hide the laik info
        self.vwLaikDescrLeftConstraint.animateHide()
        self.animEngine.animateHide(self.btnMain, completion: nil)
        // set the status to hidden
        self.menuStatus = enumStatus.iconsHidden
    }
    
    
    func unselectAllButtons() {
        if self.showTotals == false {
            for i in (0..<self.btnIcons.count){
                let btn = self.btnIcons[i]
                btn.isTapped = false
            }
            self.btnSelectedCount = 0
        }
        
        
    }
    
    
    
    func specificPointOnCircle(radius:Float, center:CGPoint, angle:CGFloat) -> CGPoint {
                
        let theta = Float(angle * CGFloat(M_PI) / 180)
        let x = radius * cosf(theta)
        let y = radius * sinf(theta)
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
        
    }
    
    

    
    func btnSelectionChanged(sender: LMBtnLike, isSelected: Bool) {
        
        
        
        // if the menu is showing own laik totals
        if self.showTotals == true {
            // set the laik description
            self.lblLikeDescr.text = sender.likeDescr
            // if last icon clicked = sender, hide the laiks description
            // else show the description and set it's background color
            if sender.index == laikLastIconClicked {
                self.vwLaikDescrLeftConstraint.animateHide()
                self.laikLastIconClicked = -1
            } else {
                self.animEngine.animateBackgroundColor(self.vwLikeDescr, backColor: sender.btnColor, alpha: 0.6)
                self.vwLaikDescrLeftConstraint.animateShow()
                self.laikLastIconClicked = sender.index
            }
            
        } else {
            if sender.isSaved == false{
                if isSelected == true {
                    btnSelectedCount = btnSelectedCount + 1
                    // set the menu status to visible
                    if btnSelectedCount == 1 {
                        self.menuStatus = enumStatus.iconsSelected
                    }
                } else {
                    btnSelectedCount = btnSelectedCount - 1
                    if btnSelectedCount == 0 {
                        self.menuStatus = enumStatus.iconsDeselected
                    }
                }

            }
        }
    }

    
    
}
