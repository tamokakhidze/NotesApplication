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
    private let icon: UIImageView = {
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
        cancelButton.layer.cornerRadius = Sizing.Button.cancelButtonCornerRadius
        cancelButton.setTitle(StringConstants.Alert.cancelTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = .white
        deleteButton.backgroundColor = .red
        deleteButton.layer.cornerRadius = Sizing.Button.deleteButtonCornerRadius
        deleteButton.setTitle(StringConstants.Alert.deleteTitle, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return deleteButton
    }()
    
    private let buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = Sizing.Alert.stackViewSpacing
        buttonsStackView.alignment = .center
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
        
    }()
    
    private let alertMessage: UILabel = {
        let message = UILabel()
        message.text = StringConstants.Alert.message
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textColor = .white
        message.font = .systemFont(ofSize: Sizing.Alert.messageFontSize)
        message.numberOfLines = .zero
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
        layer.cornerRadius = Sizing.Alert.cornerRadius
        
        setupHierarchy()
        
        setConstraints()
    }
    
    private func setupHierarchy() {
        buttonsStackView.addArrangedSubviews(cancelButton, deleteButton)
        addSubviews(icon, alertMessage, buttonsStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: Sizing.Alert.iconTopAnchor),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            alertMessage.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: Sizing.Alert.messageTopAnchor),
            alertMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertMessage.widthAnchor.constraint(equalToConstant: Sizing.Alert.messageWidth),
            alertMessage.heightAnchor.constraint(equalToConstant: Sizing.Alert.messageHeight),
            
            cancelButton.widthAnchor.constraint(equalToConstant: Sizing.Alert.buttonsWidth),
            deleteButton.widthAnchor.constraint(equalToConstant: Sizing.Alert.buttonsWidth),

            buttonsStackView.topAnchor.constraint(equalTo: alertMessage.bottomAnchor, constant: Sizing.Alert.buttonsStackViewTopAnchor),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
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
