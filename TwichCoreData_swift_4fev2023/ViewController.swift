//
//  ViewController.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 04/02/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    var container : NSPersistentContainer!
    
    
    var names:[String] = ["Julien","Dylan","Pierric"]  /// <----- array of string  >
    var people : [NSManagedObject] = []

    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addName: UINavigationItem!
    
    @IBAction func addNameAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Nom", message: "AJouter nom", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "SAVE", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            
            self.save(name: nameToSave)
            self.tableview.reloadData()
        }
            alert.addTextField()
            alert.addAction(saveAction)
        
            present(alert,animated: true)
        }
    
    func save(name:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // on récupère la référence vers la db soit le persistentContainer
        let managementContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managementContext)!
        let person = NSManagedObject(entity: entity, insertInto: managementContext)
        person.setValue(name, forKey: "name")
        do {
            try managementContext.save()
            people.append(person)
        }catch let error as NSError {
            print("pas possible de sauvegarder \(error), \(error.userInfo)")
        }
        
        
    }
    
                
                
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "The Liste"
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableview.delegate = self
        tableview.dataSource = self
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managementContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Erreur \(error) \(error.userInfo)")
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }


}


extension ViewController : UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = people[indexPath.row]
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appDelegate.persistentContainer.viewContext.delete(commit)
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
          
            
            let managementContext = appDelegate.persistentContainer.viewContext
            
            do {
                try managementContext.save()
               
            }catch let error as NSError {
                print("pas possible de sauvegarder \(error), \(error.userInfo)")
            }
        
            
         
            
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    
    
    
}

