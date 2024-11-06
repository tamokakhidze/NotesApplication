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
        contentView.layer.cornerRadius = Sizing.NoteCell.cornerRadius
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
        titleLabel.heightAnchor.constraint(equalToConstant: Sizing.NoteCell.titleHeight).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Sizing.NoteCell.titleWidth).isActive = true
        titleLabel.numberOfLines = Sizing.NoteCell.titleNumberOfLines
        titleLabel.font = .systemFont(ofSize: Sizing.NoteCell.titleFontSize)
        return titleLabel
    }
    
    private func configureDeleteButton() -> UIButton {
        let deleteButton = UIButton()
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.heightAnchor.constraint(equalToConstant: Sizing.Button.cellDeleteButtonHeight).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: Sizing.Button.cellDeleteButtonHeight).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Sizing.NoteCell.deleteButtonAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Sizing.NoteCell.deleteButtonAnchor).isActive = true
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.backgroundColor = .darkGray
        deleteButton.layer.cornerRadius = Sizing.Button.cellDeleteButtonCornerRadius
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
