//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

final class AddNoteViewController: UIViewController {

    //MARK: - Properties
    private var titleTextField = UITextField()
    private var descriptionTextField = UITextField()
    private var saveButton = UIButton()
    var titleText: String?
    var descriptionText: String?
    private var saveButtonClicked: (() -> Void)?
    var noteID: NSManagedObjectID?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        CoreDataManager.shared.retrieveData()
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        let backButton = BackButton(width: 48, height: 48, backgroundImage: "backButtonImage", backgroundColor: .mediumGray)
        backButton.setImage(UIImage(named: "backButtonImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.title = ""
        
        view.backgroundColor = .background
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        if let title = titleText {
            titleTextField.text = title
        }
        if let description = descriptionText {
            descriptionTextField.text = description
        }
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        configureTitleTextField()
        configureDescriptionTextField()
        configureSaveButton()
    }
    
    private func configureTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 141).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        titleTextField.font = .systemFont(ofSize: 35)
        titleTextField.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholder
        ]
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: attributes)
        
    }
    
    private func configureDescriptionTextField() {
        view.addSubview(descriptionTextField)
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        descriptionTextField.textColor = .white
        descriptionTextField.font = .systemFont(ofSize: 22)
        descriptionTextField.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholder
        ]
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Type something...", attributes: attributes)
        
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    //MARK: - Actions
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveInfoToCoreData), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveInfoToCoreData() {
        CoreDataManager.shared.createData(title: titleTextField.text ?? "Could not save what u wrote - title", description: descriptionTextField.text ?? "Could not save what u wrote - description")
        navigationController?.popViewController(animated: true)
        print("------------------------save clicked")
    }
    
}

extension AddNoteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let noteID = noteID,
              let note = managedContext.object(with: noteID) as? NSManagedObject else {
            return
        }
        
        if textField == titleTextField {
            note.setValue(textField.text, forKey: "title")
        } else if textField == descriptionTextField {
            note.setValue(textField.text, forKey: "descriptionBody")
        }
        
        do {
            try managedContext.save()
            print("Note updated successfully.")
        } catch {
            print("Failed to update note: \(error)")
        }
    }

}
