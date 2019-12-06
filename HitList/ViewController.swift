//
//  ViewController.swift
//  HitList
//
//  Created by ParksPlus on 12/5/19.
//  Copyright © 2019 ajpauga. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
           [unowned self] action in
           
           guard let textField = alert.textFields?.first,
             let nameToSave = textField.text else {
               return
           }
           
           self.save(name: nameToSave)
           self.tableView.reloadData()        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do{
            try managedContext.save()
            people.append(person)
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1 You need to get a managed object context
        //You first get the application delegate
        guard let appDelagate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        //Through the app delegate you get the persistentContainers view context
        let managedContext = appDelagate.persistentContainer.viewContext
        
        //2 Go and fetch the information you want from cored data
        //Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3 You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.
        do{
            people = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    
    
}
