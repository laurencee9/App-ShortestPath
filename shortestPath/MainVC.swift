//
//  MainVC.swift
//  shortestPath
//
//  Created by Mamadou on 16-04-25.
//  Copyright © 2016 Mamadou. All rights reserved.
//

import UIKit
import FontAwesomeKit
import CoreData


//let stud1 = Student(name: "Test1")
//let stud2 = Student(name: "Test2")
var listStudents : [Student] = []

  

var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var managedContext = appDelegate.managedObjectContext
var entity =  NSEntityDescription.entityForName("Student", inManagedObjectContext: managedContext)

func saveStudent(student : Student) {
    
    
    //2
//    let fetchRequest = NSFetchRequest(entityName:"Student")
    //3
//    var error: NSError?
//    let fetchedResults = managedContext.executeFetchRequest(fetchRequest) as [NSManagedObject]?
    
    var stud = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    stud.setValue(student.name, forKey: "name")
    stud.setValue(student.score, forKey: "score")
    
    let transformer : NSValueTransformer = NSValueTransformer(forName: NSKeyedUnarchiveFromDataTransformerName)!
    let transformedData  = transformer.reverseTransformedValue(student.order)
    
    stud.setValue(transformedData, forKey: "order")
    
//    if let results = fetchedResults {
//        if results.count==0{
//            
//            var person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
//            person.setValue(number, forKey: "number")
//            person.setValue(NombreTotal, forKey: "nombretotal")
//            
//        }
//        else{
//            
//            results[results.count-1].setValue(number, forKey: "number")
//            results[results.count-1].setValue(NombreTotal, forKey: "nombretotal")
//            
//        }
//    }
//    
//    // var error: NSError?
    do {
        try managedContext.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
//    else{
//        // println("save done")
//        // println(newVar.valueForKey("number"))
//    }
//    
}


func loadStudent()-> [Student] {//1
    
    //2
    let fetchRequest = NSFetchRequest(entityName:"Student")
    
    //3
//    var error: NSError?

    var u : [Student] = []
    do {
        let fetchedresults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
        if fetchedresults.count>0 {
            
        
            for i in 0..<fetchedresults.count {
                
                if let name = fetchedresults[i].valueForKey("name"), score = fetchedresults[i].valueForKey("score"), order = fetchedresults[i].valueForKey("order") {
                    
                    
                    let aa = Student(name: name as! String)
                    aa.score = score as! CGFloat
                    let transformer : NSValueTransformer = NSValueTransformer(forName: NSKeyedUnarchiveFromDataTransformerName)!
                    aa.order = transformer.transformedValue(order) as! [Int]

                    u.append(aa)
                }
            }
        }
    } catch {
        fatalError("Failed to fetch employees: \(error)")
    }
    
    
    
  
    return u
}


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    
    //UI Elements
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var summaryBtn: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if listStudents.count == 0 {
            listStudents = loadStudent()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.table.contentInset.top = -20.0
        }
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        listStudents = listStudents.sort({ $0.score < $1.score })
        self.table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configure(){
        let addIcon1 : FAKIonIcons = FAKIonIcons.iosUploadOutlineIconWithSize(30)
//        addIcon1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 72.0/255.0, green: 159.0/255.0, blue: 206.0/255.0, alpha: 1.0))
        self.summaryBtn.setAttributedTitle(addIcon1.attributedString(), forState: .Normal)
    }
    
    /*
        Table View DataSource
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStudents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : customCell =  tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customCell
        cell.nameLabel.text = listStudents[indexPath.row].name
        cell.scoreLabel.text = String(format: "%.1f", listStudents[indexPath.row].score)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc: playVC = storyboard!.instantiateViewControllerWithIdentifier("playVC") as! playVC
        vc.canModify = false
        vc.order = listStudents[indexPath.row].order
        vc.distance = listStudents[indexPath.row].score
        self.navigationController?.pushViewController(vc, animated: true)
        print("MOVE")
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("section")
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }

    
    
    @IBAction func addBtnAction(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc: playVC = storyboard!.instantiateViewControllerWithIdentifier("playVC") as! playVC
        vc.canModify = true
        vc.order = []
        vc.distance = 0.0
        self.navigationController?.pushViewController(vc, animated: true)
        print("MOVE")
    }

    @IBAction func sendBtnAction(sender: AnyObject) {
        
        var a : String = ""
        for st in listStudents{
            a += st.name+"\t"+String(st.score) + "\t"
            for rs in st.order {
                a += String(rs) + ","
            }
            a+="\n"
        }

        
//        let a : String = ""
//        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: [a], applicationActivities: nil)
//        activityVC.popoverPresentationController = self.parentViewController
//        self.presentViewController(activityVC, animated: true, completion: nil)
        
        let activityViewController = UIActivityViewController(activityItems: [a], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
            UIActivityTypePostToWeibo,
            UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo]
        
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            var currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
            if respondsToSelector("popoverPresentationController") {
                let popup = UIPopoverController(contentViewController: activityViewController)
                popup.presentPopoverFromRect(CGRect(x: self.view.frame.size.width-300, y: 0, width: 250, height: 100), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
            }else{
                currentViewController.presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
        else {
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
    }

}

