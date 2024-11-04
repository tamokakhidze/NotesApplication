//
//  ViewController.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

final class ViewController: UIViewController {

    //MARK: - Properties
    private var tableView = UITableView()
    private var viewModel = ViewModel()
    private var plusButton = UIButton()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        loadData()
        setupUI()
        addTargets()
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .background
        configureTableView()
        configurePlusButton()
        title = "Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func loadData() {
        viewModel.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 131).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -139).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        tableView.rowHeight = 110
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NotesCell")
        tableView.backgroundColor = .clear
    }
    
    private func configurePlusButton() {
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        plusButton.backgroundColor = .background
        plusButton.layer.cornerRadius = 35
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowRadius = 10
        plusButton.layer.shadowOpacity = 1
        plusButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        plusButton.setImage(UIImage(resource: .plusButton), for: .normal)
    }
    
    private func addTargets() {
        plusButton.addTarget(self, action: #selector(goToAddNotePage), for: .touchUpInside)
    }
    
    private func setDelegates() {
        CoreDataManager.shared.delegate = self
    }
    
    //MARK: - Actions
    @objc func goToAddNotePage() {
        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }

}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        CoreDataManager.shared.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell") as? NoteCell
        cell?.backgroundColor = .clear
        let note = CoreDataManager.shared.notes[indexPath.section]
        if let title = note.value(forKey: "title") as? String {
            cell?.configureCell(title: title)
        } else {
            cell?.configureCell(title: "No Title")
        }
        
        cell?.deleteAction = { [weak self] in
            self?.showDeleteAlert(for: note, at: indexPath)
        }
        return cell!
    }
    
    func showDeleteAlert(for note: NSManagedObject, at indexPath: IndexPath) {
        let alertView = BlackAlertController()
        
        alertView.cancelAction = {
            alertView.removeFromSuperview()
        }
        
        alertView.deleteAction = {
            self.deleteNote(note, at: indexPath)
            alertView.removeFromSuperview()
        }
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            alertView.frame = window.bounds
            window.addSubview(alertView)
            
            alertView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                alertView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                alertView.widthAnchor.constraint(equalToConstant: 330),
                alertView.heightAnchor.constraint(equalToConstant: 236)
            ])
        }
    }
    
    func deleteNote(_ note: NSManagedObject, at indexPath: IndexPath) {
        viewModel.deleteNote(note, at: indexPath)
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .middle)
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = CoreDataManager.shared.notes[indexPath.section]
        let addNoteVC = AddNoteViewController()
        addNoteVC.titleText = note.value(forKey: "title") as? String ?? ""
        addNoteVC.descriptionText = note.value(forKey: "descriptionBody") as? String ?? ""
        addNoteVC.noteID = note.objectID
        navigationController?.pushViewController(addNoteVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
}
//MARK: - CoreDataManagerDelegate
extension ViewController: CoreDataManagerDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
