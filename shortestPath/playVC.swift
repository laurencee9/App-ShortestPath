//
//  playVC.swift
//  shortestPath
//
//  Created by Mamadou on 16-04-25.
//  Copyright © 2016 Mamadou. All rights reserved.
//

import Foundation
import UIKit
import FontAwesomeKit
import pop
let positionX30 : [CGFloat] = [99.2737448134/840.0, 46.2177337383/840.0, 120.045368228/840.0, 721.212527429/840.0, 143.540197661/840.0, 571.776370434/840.0, 598.126366262/840.0, 52.115941352/840.0, 42.0417736644/840.0, 538.741292385/840.0, 518.263481391/840.0, 175.365846421/840.0, 175.70652408/840.0, 509.487904781/840.0, 665.220546953/840.0, 107.843690692/840.0, 250.572810286/840.0, 348.2325276/840.0, 700.317947042/840.0, 204.30380195/840.0, 71.2228867334/840.0, 69.1649534744/840.0, 167.664070007/840.0, 704.333028349/840.0, 62.667805421/840.0, 468.002140249/840.0, 673.483206803/840.0, 27.7030413392/840.0, 676.982104859/840.0, 409.041472308/840.0, 311.060650468/840.0, 469.016219537/840.0, 760.052660047/840.0, 418.631829301/840.0, 170.458711362/840.0, 84.7865298883/840.0, 2.10817852813/840.0, 260.881608219/840.0, 721.24024426/840.0, 674.855593939/840.0]


let positionY30 : [CGFloat] = [413.89742215/520.0, 438.789689817/520.0, 384.84428207/520.0, 221.231401317/520.0, 460.034796674/520.0, 423.445591388/520.0, 363.78246882/520.0, 362.845977451/520.0, 459.012119514/520.0, 499.648279021/520.0, 256.729353652/520.0, 263.598711876/520.0, 171.529593994/520.0, 212.115976035/520.0, 408.300863372/520.0, 264.153691021/520.0, 365.890211866/520.0, 391.23662671/520.0, 139.097490435/520.0, 49.0149379327/520.0, 135.818792046/520.0, 372.189666315/520.0, 22.2073475458/520.0, 470.192164411/520.0, 303.99162489/520.0, 384.276077105/520.0, 218.485369279/520.0, 4.29410560891/520.0, 505.685655293/520.0, 393.866678316/520.0, 103.5628732/520.0, 22.9617359038/520.0, 342.742692415/520.0, 180.135332476/520.0, 70.0089350245/520.0, 39.0610218328/520.0, 7.33945030114/520.0, 228.317160901/520.0, 344.087021138/520.0, 87.929330981/520.0]

class Circle : UIView {
    
    var identity : Int!
    var istouched : Bool = false
    func configure(){
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
             self.layer.borderWidth = 3.0
        }
        else{
             self.layer.borderWidth = 5.0
        }
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.frame.height/2.0
       
        self.layer.borderColor = UIColor.grayColor().CGColor
    }
}




class playVC : UIViewController {
    
    
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var scorePoint: UILabel!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    
    var positionX : [CGFloat] = []
    var positionY : [CGFloat] = []
    
    var listCircle : [Circle] = []
    var listPath : [CAShapeLayer] = []
    var order : [Int] = []
    var sizeCircle : CGFloat = 20.0
    var lastPosition : CGPoint  = CGPoint(x: -1, y: -1)
    var distance : CGFloat = 0.0
    
    var canModify : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initiateCircle()
//        self.configure()
        if canModify == false {
            self.configureRead()
        }
        else{
            self.configure()
        }
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.initiateCircle()
        if self.canModify == false {
            self.doOnePath()
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureRead(){
        self.eraseBtn.alpha = 0.0
        self.endBtn.alpha = 0.0
        self.scorePoint.text = String(format: "%.1f", self.distance)
        let addIcon2 : FAKIonIcons = FAKIonIcons.iosArrowBackIconWithSize(40)
        //        addIcon2.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 72.0/255.0, green: 159.0/255.0, blue: 206.0/255.0, alpha: 1.0))
        self.backBtn.setAttributedTitle(addIcon2.attributedString(), forState: .Normal)
    
        
    }
    
    func doAnimation(i : Int){
        if i<self.order.count-1{
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: self.listCircle[self.order[i]].frame.origin.x + sizeCircle/2.0, y: self.listCircle[self.order[i]].frame.origin.y + sizeCircle/2.0))
            let a : CGPoint = CGPoint(x: self.listCircle[self.order[i+1]].frame.origin.x + sizeCircle/2.0, y: self.listCircle[self.order[i+1]].frame.origin.y + sizeCircle/2.0)
            path.addLineToPoint(a)
            
            let shapeLayer : CAShapeLayer = CAShapeLayer()
            shapeLayer.path = path.CGPath
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = UIColor.orangeColor().CGColor
            shapeLayer.strokeEnd = 0.0
            shapeLayer.lineWidth = 9.0
            self.masterView.layer.insertSublayer(shapeLayer, atIndex: 0)
            
//            self.listPath.append(shapeLayer)
            
            let animation : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
            animation.duration = CFTimeInterval(0.11)
//            animation.
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.fromValue = 0.0
            animation.toValue = 1.0

            animation.completionBlock = {(animation, finished) in
                let anim2 : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
//                anim2.duration = CFTimeInterval(0.3)
//                anim2.toValue = 
//                    CGPointMake(1.0, 1.0)
                anim2.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
                anim2.velocity = NSValue(CGPoint: CGPointMake(3, 3))
                anim2.springBounciness = 20.0
                self.listCircle[self.order[i+1]].pop_addAnimation(anim2, forKey: "caca")
                self.listCircle[self.order[i+1]].layer.borderColor = UIColor.orangeColor().CGColor
                self.doAnimation(i+1)
            }

            shapeLayer.pop_addAnimation(animation, forKey: "storkened")
        }
        
        
        
        
    }
    func doOnePath(){
        self.listCircle[self.order[0]].layer.borderColor = UIColor.orangeColor().CGColor
        doAnimation(0)

    }
    
 
    
    
    func configure(){
        let addIcon1 : FAKIonIcons = FAKIonIcons.iosUndoIconWithSize(40)
//        addIcon1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 72.0/255.0, green: 159.0/255.0, blue: 206.0/255.0, alpha: 1.0))
        self.eraseBtn.setAttributedTitle(addIcon1.attributedString(), forState: .Normal)
        
        let addIcon2 : FAKIonIcons = FAKIonIcons.iosArrowBackIconWithSize(40)
//        addIcon2.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 72.0/255.0, green: 159.0/255.0, blue: 206.0/255.0, alpha: 1.0))
        self.backBtn.setAttributedTitle(addIcon2.attributedString(), forState: .Normal)
        
        self.endBtn.alpha = 0.3
//        self.endBtn.enab

    }
    
    func doOrder(){
        
    }
    
    func initiateCircle(){
        
        print(self.masterView.frame.size)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            print("Phone")
            self.positionX = positionY30
            self.positionY = positionX30
        }
        else{
            self.sizeCircle = 30.0
            self.positionX = positionX30
            self.positionY = positionY30
        }

        for i in 0..<positionX.count {
            let newCircle : Circle = Circle()
            newCircle.identity = i
            newCircle.frame = CGRect(x: positionX[i]*self.masterView.frame.size.width-self.sizeCircle/2.0, y: positionY[i]*self.masterView.frame.size.height-self.sizeCircle/2.0, width:self.sizeCircle, height: self.sizeCircle)
            newCircle.configure()
            self.masterView.addSubview(newCircle)
            self.listCircle.append(newCircle)
        }
    }
    
    func linkNodes(newNodeIndex : Int){

        let newPositionX = self.listCircle[newNodeIndex].frame.origin.x + sizeCircle/2.0
        let newPositionY = self.listCircle[newNodeIndex].frame.origin.y + sizeCircle/2.0
        
        let path = UIBezierPath()
        path.moveToPoint(lastPosition)
        path.addLineToPoint(CGPoint(x: newPositionX, y: newPositionY))
        
        //design path in layer
        let shapeLayer : CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = UIColor.orangeColor().CGColor
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            shapeLayer.lineWidth = 9.0
        }
        else{
            shapeLayer.lineWidth = 14.0
        }
//        shapeLayer.lineWidth = 9.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.lineJoin = kCALineJoinBevel
        self.masterView.layer.insertSublayer(shapeLayer, atIndex: 0)
//        self.masterView.layer.addSublayer(shapeLayer)
        self.listPath.append(shapeLayer)
        
        
//        shapeLayer.pop_removeAllAnimations()
        let animation : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation.duration = CFTimeInterval(0.3)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        shapeLayer.pop_addAnimation(animation, forKey: "storkened")
        
        
        
        let anim2 : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        //                anim2.duration = CFTimeInterval(0.3)
        //                anim2.toValue =
        //                    CGPointMake(1.0, 1.0)
        anim2.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        anim2.velocity = NSValue(CGPoint: CGPointMake(6, 6))
        anim2.springBounciness = 20.0
        self.listCircle[newNodeIndex].pop_addAnimation(anim2, forKey: "caca")
        self.listCircle[newNodeIndex].layer.borderColor = UIColor.orangeColor().CGColor

        
        
        self.distance +=  getDistance(newNodeIndex, j: self.order[self.order.count-1])
        self.scorePoint.text = String(format: "%.1f", self.distance)
        
        
    }
    
    func getDistance(i : Int, j:Int) -> CGFloat{
        let w = (positionX[i]-positionX[j])*self.masterView.frame.size.width
        let h = (positionY[i]-positionY[j])*self.masterView.frame.size.height
        var l : CGFloat = w*w
        l +=  h*h
        return CGFloat(sqrt(Double(l)))/100.0
    }
    
    func animateEndButton(){
        self.endBtn.alpha = 1.0
        let anim2 : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        anim2.fromValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        anim2.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        anim2.velocity = NSValue(CGPoint: CGPointMake(3, 3))
        anim2.springBounciness = 20.0
//        anim2.t
        self.endBtn.pop_addAnimation(anim2, forKey: "asd")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if canModify {
            let touch: UITouch = touches.first!
            let location = touch.locationInView(self.masterView)
            //        print(location)
            
            var around : CGFloat = 20.0
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                around = 30.0
            }

            for circle in self.listCircle {
                if circle.istouched == false && location.x > circle.frame.origin.x + self.sizeCircle/2.0 - around  && location.x < circle.frame.origin.x + self.sizeCircle/2.0 + around && location.y > circle.frame.origin.y + self.sizeCircle/2.0 - around && location.y < circle.frame.origin.y + self.sizeCircle/2.0 + around {
                    //                print(circle.identity)
                    
                    if self.listPath.count > 0{
                        linkNodes(circle.identity)
                        
                    }
                    else{
                        if self.lastPosition.x > 0 {
                            linkNodes(circle.identity)
                            
                        }
                    }
                    self.lastPosition = CGPoint(x: self.listCircle[circle.identity].frame.origin.x + sizeCircle/2.0, y: self.listCircle[circle.identity].frame.origin.y + sizeCircle/2.0)
                    self.order.append(circle.identity)
                    circle.istouched = true
                    circle.layer.borderColor = UIColor.orangeColor().CGColor
                    break
                }
            }
            if self.order.count == self.positionX.count {
                self.animateEndButton()
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if canModify {
        let touch: UITouch = touches.first!
        let location = touch.locationInView(self.masterView)
//        print(location)
        let around : CGFloat = self.sizeCircle + 10.0
        
        for circle in self.listCircle {
            if circle.istouched == false && location.x > circle.frame.origin.x + self.sizeCircle/2.0 - around  && location.x < circle.frame.origin.x + self.sizeCircle/2.0 + around && location.y > circle.frame.origin.y + self.sizeCircle/2.0 - around && location.y < circle.frame.origin.y + self.sizeCircle/2.0 + around {
//                print(circle.identity)
                
                if self.listPath.count > 0{
                    linkNodes(circle.identity)
 
                }
                else{
                    if self.lastPosition.x > 0 {
                        linkNodes(circle.identity)
                       
                    }
                }
                self.lastPosition = CGPoint(x: self.listCircle[circle.identity].frame.origin.x + sizeCircle/2.0, y: self.listCircle[circle.identity].frame.origin.y + sizeCircle/2.0)
                self.order.append(circle.identity)
                circle.istouched = true
                circle.layer.borderColor = UIColor.orangeColor().CGColor
                break
            }
        }
            if self.order.count == self.positionX.count {
                self.animateEndButton()
            }
        }
        
    }
    
    
    
    @IBAction func returnBtn(sender: AnyObject) {
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func eraseMoveBtn(sender: AnyObject) {
        if canModify {
        self.endBtn.alpha = 0.3
        if self.order.count>0{
            if self.order.count == 2 {
                
                for i in self.order {
                    self.listCircle[i].istouched = false
                    self.listCircle[i].layer.borderColor = UIColor.grayColor().CGColor
                }
                
                self.order = []
                self.lastPosition = CGPoint(x: -1, y: -1)
                for i in self.listPath {
                    i.removeFromSuperlayer()
                }
                self.listPath = []
                
                self.distance = 0.0
                self.scorePoint.text = String(format: "%.1f", self.distance)
                
            }
                
            else{
                let lastindex = self.order[self.order.count-1]
                self.distance -=  getDistance(lastindex, j:self.order[self.order.count-2])
                
                self.order.removeAtIndex(self.order.count-1)
                self.listCircle[lastindex].istouched = false
                self.listCircle[lastindex].layer.borderColor = UIColor.grayColor().CGColor
                
                
                
                self.scorePoint.text = String(format: "%.1f", self.distance)
                
                

                self.lastPosition = CGPoint(x: self.listCircle[self.order[self.order.count-1]].frame.origin.x + sizeCircle/2.0, y: self.listCircle[self.order[self.order.count-1]].frame.origin.y + sizeCircle/2.0)
                
                self.listPath[self.listPath.count-1].removeFromSuperlayer()
                self.listPath.removeAtIndex(self.listPath.count-1)

            }
        }
        }

    }
    @IBAction func finishBtn(sender: AnyObject) {
        if canModify {
        if self.order.count == positionX.count {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Sauvegarder votre résultat", message: "Entrez votre nom", preferredStyle: .Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = "Nom"
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if let a = textField.text {
                    let newStudent =  Student(name: a)
                    newStudent.order = self.order
                    newStudent.score = self.distance
                    listStudents.append(newStudent)
                    saveStudent(newStudent)
                }
                print(self.order)
                
                
                self.navigationController!.popToRootViewControllerAnimated(true)

            }))
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Sauvegarder", message: "Vous devez connecter tous les points.", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                 alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            

            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        }
    }
    
}
