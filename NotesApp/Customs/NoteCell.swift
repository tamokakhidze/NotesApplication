//
//  NoteCell.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

final class NoteCell: UITableViewCell {
    
    //MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = Sizing.NoteCell.titleNumberOfLines
        label.font = .systemFont(ofSize: Sizing.NoteCell.titleFontSize)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = Sizing.Button.cellDeleteButtonCornerRadius
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    static let identifier = "NoteCell"
    var deleteAction: (() -> Void)?
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    private func initialise() {
        setupUI()
        setupHierarchy()
        setConstraints()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = Sizing.NoteCell.cornerRadius
        contentView.backgroundColor = .cell
        sendSubviewToBack(contentView)
        contentView.clipsToBounds = true
    }
    
    private func setupHierarchy() {
        addSubviews(titleLabel, deleteButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: Sizing.NoteCell.titleHeight),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Sizing.NoteCell.titleWidth),
            
            deleteButton.heightAnchor.constraint(equalToConstant: Sizing.Button.cellDeleteButtonHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: Sizing.Button.cellDeleteButtonHeight),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Sizing.NoteCell.deleteButtonAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Sizing.NoteCell.deleteButtonAnchor)
        ])
    }
    
    //MARK: - Actions
    @objc func deleteButtonTapped() {
        deleteAction?()
    }
    
    //MARK: - Cell Configuration
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
