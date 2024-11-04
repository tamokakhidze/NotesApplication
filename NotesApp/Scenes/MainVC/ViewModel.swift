//
//  ViewModel.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import Foundation
import CoreData

//MARK: - ViewModel
class ViewModel {
    
    //MARK: - Methods
    func viewDidLoad() {
        CoreDataManager.shared.retrieveData()
    }
    
    func deleteNote(_ note: NSManagedObject, at indexPath: IndexPath) {
        CoreDataManager.shared.deleteData(note: note)
        CoreDataManager.shared.notes.remove(at: indexPath.section)
    }
    
}
