//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

//MARK: - Protocols
protocol CoreDataManagerDelegate: AnyObject {
    func reloadTableView()
}

//MARK: - CoreDataManager
final class CoreDataManager {
    
    //MARK: - Properties
    public static let shared = CoreDataManager()
    weak var delegate: CoreDataManagerDelegate?
    var viewModel = ViewModel()
    var notes: [NSManagedObject] = []
    
    //MARK: - Init
    private init() {}
    
    //MARK: - Methods
    func createData(title: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let notesEntity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)!
        
        let note = NSManagedObject(entity: notesEntity, insertInto: managedContext)
        note.setValue(title, forKey: "title")
        note.setValue(description, forKey: "descriptionBody")
        note.setValue(Date(), forKey: "dateAdded")
        
        do {
            try managedContext.save()
            notes.insert(note, at: 0)
            delegate?.reloadTableView()
        } catch let error as NSError {
            print("Could not save items. error: \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            notes = result
            delegate?.reloadTableView()
            for data in result {
                print("Values: \(data.value(forKey: "title") as Any)")
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
            print("Deleted note successfully.")
            delegate?.reloadTableView()
        } catch let error as NSError {
            print("Could not save context after deletion. error: \(error), \(error.userInfo)")
        }
    }
    
}
