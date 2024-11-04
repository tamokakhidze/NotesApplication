//
//  NoteCell.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit
import CoreData

final class NoteCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var deleteButton = UIButton()
    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = configureTitleLabel()
        deleteButton = configureDeleteButton()
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .cell
        sendSubviewToBack(contentView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.heightAnchor.constraint(equalToConstant: 67).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 290).isActive = true
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        return titleLabel
    }
    
    private func configureDeleteButton() -> UIButton {
        let deleteButton = UIButton()
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.backgroundColor = .darkGray
        deleteButton.layer.cornerRadius = 15
        deleteButton.tintColor = .white
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return deleteButton
    }
    
    @objc func deleteButtonTapped() {
        deleteAction?()
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
