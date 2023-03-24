//
//  DogViewController.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 14/02/2023.
//

import UIKit
import CoreData

class DogViewController: UIViewController {
    
    
    var currentDog:Dog?

    // MARK : - Property

    @IBOutlet weak var tableview: UITableView!
    lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        formater.dateFormat = "hh:mm dd-MM-yyyy"
        
        return formater
    }()
    
    lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .medium
      return formatter
    }()
    
    
    
    lazy var coreDataStack = CoreDataStack(modelName: "dbname")
    var promenades : [Date] = []
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let dogName = "Swifty"
        let dogFetch : NSFetchRequest<Dog> = Dog.fetchRequest()
        dogFetch.predicate = NSPredicate(format: "%K == %@",#keyPath(Dog.name), dogName)
        do {
            let results = try coreDataStack.managedContext.fetch(dogFetch)
            if results.isEmpty {
                print("Vide")
                currentDog = Dog(context: coreDataStack.managedContext)
                currentDog?.name = dogName
                coreDataStack.saveContext()
              
            }else {
                print("existe deja")
                currentDog = results.first
            }
            
            
        } catch let error as NSError {
            print("Fetch error : \(error) description: \(error.userInfo)")
        }
        
 
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ajoutPromenade(_ sender: Any) {
 
        let walk = Walk(context: coreDataStack.managedContext)
        walk.date = Date()

        if let dog = currentDog,
          let walks = dog.walks?.mutableCopy()
            as? NSMutableOrderedSet {
            walks.add(walk)
            dog.walks = walks
        }

        coreDataStack.saveContext()
        tableview.reloadData()
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DogViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(promenades.count)
       
        return currentDog?.walks?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        guard let walk = currentDog?.walks?[indexPath.row] as? Walk, let walkDate = walk.date as Date? else {
            return cell
        }
    
        cell.textLabel?.text = dateFormater.string(from: walkDate)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
}
