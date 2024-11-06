//
//  AddNoteViewModel.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import Foundation

//MARK: - AddNoteViewModel
class AddNoteViewModel {
    
    //MARK: - Methods
    func viewDidLoad() {
        CoreDataManager.shared.retrieveData()
    }
    
    func savePressed(title: String?, description: String?) {
        CoreDataManager.shared.createData(title: title ?? "Could not save what u wrote - title", description: description ?? "Could not save what u wrote - description")
    }
}
