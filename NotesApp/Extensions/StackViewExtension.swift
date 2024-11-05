//
//  StackViewExtension.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 05.11.24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
}
