//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManagerDelegate: AnyObject {
    func reloadTableView()
}

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    var viewModel = ViewModel()
    var notes: [NSManagedObject] = []
    private init() {}
    weak var delegate: CoreDataManagerDelegate?
    
    func createData(title: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let notesEntity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)!
        
        let note = NSManagedObject(entity: notesEntity, insertInto: managedContext)
        note.setValue(title, forKey: "title")
        note.setValue(description, forKey: "descriptionBody")
        
        do {
            try managedContext.save()
            notes.append(note)
            print("data saved")
            print("and this is array\(note)")
            delegate?.reloadTableView()
        } catch let error as NSError {
            print("Could not save items. error: \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            notes = result
            delegate?.reloadTableView()
            for data in result {
                print("So this is values: \(data.value(forKey: "title") as Any)")
            }
        } catch {
            print("Failed to retrieve data")
        }
    }
    
    func deleteData(note: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(note)
        
        do {
            try managedContext.save()
            print("Deleted note sucessfully.")
            delegate?.reloadTableView()
        } catch let error as NSError {
            print("Could not save context after deletion. error: \(error), \(error.userInfo)")
        }
    }
    
}
