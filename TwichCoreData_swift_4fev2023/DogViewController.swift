//
//  DogViewController.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 14/02/2023.
//

import UIKit
import CoreData

class DogViewController: UIViewController {
    
    

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
    
    
    
    lazy var coreDataStack = CoreDataStack(modelName: "DogWal")
    var promenades : [Date] = []
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ajoutPromenade(_ sender: Any) {
        promenades.append(Date())
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
        print(promenades.count)
        return promenades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = promenades[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = dateFormater.string(from: date)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
}
