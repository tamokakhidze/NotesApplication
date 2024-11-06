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
    private var descriptionTextView = UITextView()
    private var descriptionPlaceholderLabel = UILabel()
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
        setViewHierarchy()
        setupNavigationBar()
        configureTitleTextField()
        configureDescriptionTextView()
        configureSaveButton()
        updateTextFields()
    }
    
    private func updateTextFields() {
        if let title = titleText {
            titleTextField.text = title
        }
        
        if let description = descriptionText {
            descriptionTextView.text = description
        }
        
        updateDescriptionPlaceholder()
    }
    
    private func updateDescriptionPlaceholder() {
        descriptionPlaceholderLabel.isHidden = !(descriptionTextView.text?.isEmpty ?? true)
    }
    
    private func setViewHierarchy() {
        view.addSubviews(titleTextField, descriptionTextView, descriptionPlaceholderLabel, saveButton)
    }
    private func setupNavigationBar() {
        let backButton = BackButton(width: Sizing.AddNoteVC.backButtonWidth,
                                    height: Sizing.AddNoteVC.backButtonHeight,
                                    backgroundImage: StringConstants.AddNoteVC.backButtonImage,
                                    backgroundColor: .mediumGray)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.title = StringConstants.AddNoteVC.navigationTitle
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureTitleTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = .systemFont(ofSize: Sizing.AddNoteVC.titleFontSize)
        titleTextField.textColor = .white
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholder
        ]
        titleTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.AddNoteVC.titlePlaceholder, attributes: attributes)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizing.AddNoteVC.titleTopAnchor),
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.AddNoteVC.titleTrailingAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.AddNoteVC.titleLeadingAnchor)
        ])
    }
    
    private func configureDescriptionTextView() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.textColor = .white
        descriptionTextView.font = .systemFont(ofSize: Sizing.AddNoteVC.descriptionFontSize)
        descriptionTextView.backgroundColor = .background
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 5)

        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalToConstant: Sizing.AddNoteVC.descriptionWidth),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Sizing.AddNoteVC.descriptionHeight)
        ])
        
        descriptionPlaceholderLabel.text = StringConstants.AddNoteVC.descriptionPlaceholder
        descriptionPlaceholderLabel.textColor = UIColor.placeholder
        descriptionPlaceholderLabel.font = .systemFont(ofSize: Sizing.AddNoteVC.descriptionFontSize)
        descriptionPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 10)
        ])

        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)

        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.AddNoteVC.saveButtonBottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.AddNoteVC.saveButtonTrailingAnchor)
        ])
    }

    private func setDelegates() {
        titleTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveInfoToCoreData), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveInfoToCoreData() {
        viewModel.savePressed(title: titleTextField.text, description: descriptionTextView.text)
        navigationController?.popViewController(animated: true)
        print("------------------------save clicked")
    }
    
}

//MARK: - UITextFieldDelegate
extension AddNoteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let noteID = noteID else {
            return
        }
        
        let note = managedContext.object(with: noteID)
        
        if textField == titleTextField {
            note.setValue(textField.text, forKey: "title")
        }
        
        do {
            try managedContext.save()
            print("Note updated successfully.")
        } catch {
            print("Failed to update note: \(error)")
        }
    }
    
}

//MARK: - UITextViewDelegate
extension AddNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let noteID = noteID else {
            return
        }
        
        let note = managedContext.object(with: noteID)
        note.setValue(descriptionTextView.text, forKey: "descriptionBody")
        
        do {
            try managedContext.save()
            print("Description updated successfully.")
        } catch {
            print("Failed to update description: \(error)")
        }
        
        descriptionPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
