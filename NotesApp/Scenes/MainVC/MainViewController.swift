//
//  ViewController.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {

    //MARK: - Properties
    private var tableView = UITableView()
    private var viewModel: ViewModel
    private var plusButton = UIButton()
    
    //MARK: - Lifecycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupNavigationBar()
    }
    
    private func loadData() {
        viewModel.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        title = StringConstants.MainVC.title
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizing.MainVC.tableViewTopAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.MainVC.tableViewBottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.MainVC.tableViewLeadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.MainVC.tableViewTrailingAnchor).isActive = true
        tableView.rowHeight = Sizing.MainVC.tableViewRowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NotesCell")
        tableView.backgroundColor = .clear
    }
    
    private func configurePlusButton() {
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.MainVC.plutButtonBottomAnchor).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.MainVC.plusButtonTrailingAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: Sizing.MainVC.plusButtonWidth).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: Sizing.MainVC.plusButtonHeight).isActive = true
        plusButton.backgroundColor = .background
        plusButton.layer.cornerRadius = Sizing.MainVC.plusButtonCornerRadius
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowRadius = Sizing.MainVC.plusButtonShadowRadius
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
        let viewModel = AddNoteViewModel()
        let viewController = AddNoteViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
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
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = CoreDataManager.shared.notes[indexPath.section]
        let addNoteVC = AddNoteViewController(viewModel: AddNoteViewModel())
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
extension MainViewController: CoreDataManagerDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}