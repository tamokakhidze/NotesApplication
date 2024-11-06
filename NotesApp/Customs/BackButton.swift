//
//  BackButton.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 04.11.24.
//

import UIKit

final class BackButton: UIButton {
    
    //MARK: - Properties
    private var width: CGFloat
    private var height: CGFloat
    
    //MARK: - Init
    init(width: CGFloat, height: CGFloat, backgroundImage: String = "", backgroundColor: UIColor) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = Sizing.Button.backButtonCornerRadius
        self.setImage(UIImage(named: backgroundImage), for: .normal)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Ui Setup
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
