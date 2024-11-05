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
    private var saveButtonClicked: (() -> Void)?
    private var viewModel: AddNoteViewModel
    var titleText: String?
    var descriptionText: String?
    var noteID: NSManagedObjectID?
    
    //MARK: - Lifecycle
    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setDelegates()
        CoreDataManager.shared.retrieveData()
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .background
    
        setupNavigationBar()
        configureTitleTextField()
        configureDescriptionTextField()
        configureSaveButton()
        
        if let title = titleText {
            titleTextField.text = title
        }
        if let description = descriptionText {
            descriptionTextField.text = description
        }
    }
    
    private func setupNavigationBar() {
        let backButton = BackButton(width: Sizing.AddNoteVC.backButtonWidth, height: Sizing.AddNoteVC.backButtonHeight, backgroundImage: StringConstants.AddNoteVC.backButtonImage, backgroundColor: .mediumGray)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.title = StringConstants.AddNoteVC.navigationTitle
        
        // Set title text attributes
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizing.AddNoteVC.titleTopAnchor).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.AddNoteVC.titleTrailingAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.AddNoteVC.titleLeadingAnchor).isActive = true
        titleTextField.font = .systemFont(ofSize: Sizing.AddNoteVC.titleFontSize)
        titleTextField.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholder
        ]
        titleTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.AddNoteVC.titlePlaceholder, attributes: attributes)
        
    }
    
    private func configureDescriptionTextField() {
        view.addSubview(descriptionTextField)
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: Sizing.AddNoteVC.descriptionWidth).isActive = true
        descriptionTextField.textColor = .white
        descriptionTextField.font = .systemFont(ofSize: Sizing.AddNoteVC.descriptionFontSize)
        descriptionTextField.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholder
        ]
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.AddNoteVC.descriptionPlaceholder, attributes: attributes)
        
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.AddNoteVC.saveButtonBottomAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.AddNoteVC.saveButtonTrailingAnchor).isActive = true
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    private func setDelegates() {
        titleTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveInfoToCoreData), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveInfoToCoreData() {
        viewModel.savePressed(title: titleTextField.text, description: descriptionTextField.text)
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
