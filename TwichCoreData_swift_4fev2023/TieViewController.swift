//
//  TieViewController.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 11/02/2023.
//

import UIKit
import CoreData

class TieViewController: UIViewController {
    
    var managedContext : NSManagedObjectContext!
    var currentTie : Tie!
    
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        guard let  selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex) else {
           return
        }
        
        let request : NSFetchRequest<Tie> = Tie.fetchRequest()
        request.predicate = NSPredicate(format :"%K = %@", argumentArray: [#keyPath(Tie.searchKey),selectedValue])
        
        do {
            let results = try managedContext.fetch(request)
            currentTie = results.first
            populate(tie: currentTie)
            
        } catch let error as NSError {
            print("erreur de récupération \(error), \(error.userInfo)")
        }
        
        
    }
    
    @IBOutlet weak var favoriteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        insertSampleData()
        
        let request: NSFetchRequest<Tie> = Tie.fetchRequest()
        let firstTitle = segmentedControl.titleForSegment(at: 0) ?? ""
        request.predicate = NSPredicate(format:"%K = %@", argumentArray: [#keyPath(Tie.searchKey), firstTitle])
        do {
            let results = try managedContext.fetch(request)
            if let tie = results.first {
                populate(tie: tie)
               
            }
          
            
            
            
         
        }catch let error as NSError  {
            print("-------------------------------------------")
            print("could not fet \(error), \(error.userInfo)")
            print("-------------------------------------------")
        }
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var ratingLabel: UILabel!
    // Editor\Create NSManagedObject Subclass….
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    
    @IBOutlet weak var nameTie: UILabel!
    
    @IBOutlet weak var lastWorm: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func WearAction(_ sender: Any) {
        currentTie.timeWorn += 1
        currentTie.lastWorn = Date()
        
        do {
            try! managedContext.save()
            populate(tie: currentTie)
            
        }catch let error as NSError {
            print("erreur de récupération : \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func RatingAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Nouveau vote", message: "Noté une cravate", preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.keyboardType = .decimalPad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default){ [weak self] _ in
            if let tetField = alert.textFields?.first {
                self?.update(rating: tetField.text)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert,animated: true)
            
    }
    
    

        
        
        
    func update(rating: String?){
        guard let ratingString = rating, let rating = Double(ratingString) else {
          return
        }
        do {
            currentTie.rating = rating
            try managedContext.save()
            populate(tie: currentTie)
            
        }catch let error as NSError {
            
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError ||
                                                      error.code == NSValidationNumberTooSmallError){
                RatingAction(rateButton!)
            }
            
            print("erreur lors de la sauvegarde \(error), \(error.userInfo)")
        }
    }
    
    
    
    @IBOutlet weak var rateButton: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func insertSampleData(){
        
        let fetch : NSFetchRequest<Tie> = Tie.fetchRequest()
        fetch.predicate = NSPredicate(format: "searchKey != nil")
        
        let tieCount = (try? managedContext.count(for: fetch)) ?? 0
        if tieCount > 0 {
            return
        }
        
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile:path!)!
        for dict in dataArray {
            let entity = NSEntityDescription.entity(forEntityName:"Tie", in: managedContext)!
            let tie = Tie(entity: entity, insertInto: managedContext)
            let tDict = dict as! [String:Any]
            tie.id = UUID(uuidString: tDict["id"] as! String)
            tie.name = tDict["name"] as? String
            tie.searchKey = tDict["searchKey"] as? String
            tie.rating = tDict["rating"] as? Double ?? 0
            
            let imageName = tDict["imageName"] as? String
            let image = UIImage(named: imageName!)
            tie.photoData = image?.pngData()
            
            tie.lastWorn = tDict["lastWorn"] as? Date
            
            let timeNumber = tDict["timesWorn"] as! NSNumber
            tie.timeWorn = timeNumber.int32Value
            
            tie.isFavorite = tDict["isFavorite"] as! Bool
            tie.url = URL(string: tDict["url"] as! String)
        }
        
        try? managedContext.save()
        
        
        
        
        
    
    }
    
    func populate(tie: Tie){
        
        currentTie = tie;
        guard let imageData = tie.photoData as Data?, let lasWorn = tie.lastWorn as Date? else {
            return
        }
        
        imageView.image = UIImage(data: imageData)
        nameTie.text = tie.name
        timesWornLabel.text = "porté \(tie.timeWorn) fois"
        ratingLabel.text = "Note : \(tie.rating)/5"
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .none
        dateFormater.dateFormat = "dd-MM-yyyy"
        lastWorm.text = "Porté la dernière fois : " + dateFormater.string(from: lasWorn)
        
        
        favoriteLabel.isHidden = !tie.isFavorite
        
        
        
    
        
        
        
        
        
        
    
    }
    
    
    

}
