//
//  BlackAlertController.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit

//MARK: - BlackAlertController
final class BlackAlertController: UIView {

    //MARK: - Properties
    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .alertIcon
        return icon
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.tintColor = .white
        cancelButton.backgroundColor = .green
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = .white
        deleteButton.backgroundColor = .red
        deleteButton.layer.cornerRadius = 5
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.alignment = .center
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
        
    }()
    
    private lazy var alertMessage: UILabel = {
        let message = UILabel()
        message.text = "Are you sure you want to delete note?"
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textColor = .white
        message.font = .systemFont(ofSize: 20)
        message.numberOfLines = 0
        message.textAlignment = .center
        return message
    }()
    
    var cancelAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: - Ui Setup
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 20
        
        addSubview(icon)
        addSubview(alertMessage)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 50),
            icon.widthAnchor.constraint(equalToConstant: 50),
            
            alertMessage.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10),
            alertMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertMessage.widthAnchor.constraint(equalToConstant: 262),
            alertMessage.heightAnchor.constraint(equalToConstant: 48),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 112),
            deleteButton.widthAnchor.constraint(equalToConstant: 112),

            buttonsStackView.topAnchor.constraint(equalTo: alertMessage.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -38)
        ])
    }
    
    //MARK: - Actions
    @objc func cancelTapped() {
        cancelAction?()
    }
    
    @objc func deleteTapped() {
        deleteAction?()
    }

}
