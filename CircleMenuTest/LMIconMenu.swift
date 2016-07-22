//
//  LMIconMenu.swift
//  CircleMenuTest
//
//  Created by Eric Bracke on 19/06/16.
//  Copyright © 2016 Eric Bracke. All rights reserved.
//

import UIKit


protocol LMIconMenuDelegate {
    func btnBack(sender: UIButton, hasLaikesSelected: Bool)
    
}


struct LMIconCollection{
    var laikIcons: [Int] = []
    var laikColors: [Int] = []
    var laikDescriptions: [String] = []
    var laikSaved: [Bool] = []
}



class LMIconMenu: UIView, LMIconBtnDelegate {
    
    
    var iconCollection: LMIconCollection! {
        didSet{
            self.menuStatus = .menuLoaded
        }
    }
    

    
    var laikLastIconClicked: Int = -1
    var btnIcons = [LMIconBtn]()
    var sender: UIViewController!
    var btnSelectedCount: Int = 0
    var showTotals = false
    var delegate: LMIconMenuDelegate?
    
    var showInfo = true {
        didSet{
            self.vwInfo.hidden = !showInfo
        }
    }

    
    var menuStatus: enumStatus = enumStatus.menuLoaded {
        didSet{
            switch self.menuStatus {
            case enumStatus.menuLoaded:
                // show the main button with a 3sec delay
                self.animEngine.animateShow(self.btnMain, duration: 0.8, delay: 3, completion: nil)
                break
            case enumStatus.iconsCreated:
                self.showButtons()
                break
            default:
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
    @IBOutlet weak var btnBack: UIButton!
    
  
    
    @IBOutlet weak var vwLaikDescrLeftConstraint: LMPopXConstraint!
    
    
    
    @IBAction func btnHide(sender: AnyObject) {
        self.animEngine.animateHide(self.vwInfo, duration: 1, delay: 0, completion: nil)
        
    }

    

    
    @IBAction func btnMain(sender: AnyObject) {
        
        switch self.menuStatus {
        case enumStatus.menuLoaded:
            self.createIcons()
        case enumStatus.iconsCreated:
            showButtons()
            break
        default:
            break
        }

    }
  
    
    @IBAction func btnBack(sender: UIButton) {
        
        if let delegate = self.delegate {
            var laiksSelected: Bool = false
            
            if self.btnSelectedCount > 0 {
                laiksSelected = true
            }
            delegate.btnBack(sender, hasLaikesSelected: laiksSelected)
        }
        
    }

    
    override func awakeFromNib() {
        
        self.addGesture()
        self.vwBackground.layer.cornerRadius = 4
        self.btnMain.alpha = 0
        self.animEngine = AnimationEngine()
        // hide the liaksdescription view
        self.vwLaikDescrLeftConstraint.hideViewRight()
        
        
        // sow / hide the info text how to use the control
        if self.showInfo == false {
            self.vwInfo.hidden = true
        }
    }
    

    

    
    
    
    
    
    func createIcons(){
            
            print("creating icons")
            
            // clear the array first
            btnIcons.removeAll()
            
            var angle: CGFloat = 0.0
            let increm: CGFloat = 360.0 / CGFloat(self.iconCollection.laikIcons.count)
            let radius = Float(lmCalcSizeFromSixPlusBase(100))
            let radiusOffScreen = Float(UIScreen.mainScreen().bounds.size.height)
            let centralPoint = self.btnMain.center
        
//            print("centralPoint \(centralPoint)")
        
            
            
            for i in (0..<self.iconCollection.laikIcons.count) {
                let c = self.iconCollection.laikIcons[i]
                let btn: LMIconBtn = LMIconBtn(frame: self.btnMain.frame, imageIndex: c, laiksTotal: c, showTotals: self.showTotals)
                
                // set the description, index, color ans status
                btn.likeDescr = "\(c) \(self.iconCollection.laikDescriptions[i])"
                btn.index = i
                btn.btnColor = self.iconCollection.laikColors[i]
                //btn.isTapped = false
                // set the points to move the icon to
                btn.btnCirclePoint = self.specificPointOnCircle(radius, center: centralPoint, angle: angle)
                btn.btnCircleOffScreenPoint = self.specificPointOnCircle(radiusOffScreen, center: centralPoint, angle: angle)
                btn.center = centralPoint
                btn.btnCenter = centralPoint
                angle = angle + increm
                // set the delegate
                btn.delegate = self
                // hide the icon
                btn.alpha = 0
                btn.isSaved = self.iconCollection.laikSaved[i]
                btn.setupTargets()
                // add it to the view
                self.vwButtons.addSubview(btn)
                // add it to the btnIcons array
                btnIcons.append(btn)
                self.bringSubviewToFront(btn)
            }
        
            self.btnSelectedCount = 0

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
            self.btnMain.pop_removeAllAnimations()
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
        
        self.animEngine.animateButtonsDistribution(false)
        self.animEngine.animateHide(self.btnMain, completion: nil)
        
        // set the status at the end of the proc!!
        self.menuStatus = enumStatus.iconsVisible
        
    }
    

    
    func hideButtons() {
        
        self.animEngine.animateButtonsOffScreen(false)
        // hide the laik info
        self.vwLaikDescrLeftConstraint.animateHide()
//        self.animEngine.animateHide(self.btnMain, completion: nil)
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
    
    

    
    func btnSelectionChanged(sender: LMIconBtn, isSelected: Bool) {
        
        
        
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
                self.animEngine.animateBackgroundColorView(self.vwLikeDescr, backColor: sender.btnColor, alpha: 0.6)
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
