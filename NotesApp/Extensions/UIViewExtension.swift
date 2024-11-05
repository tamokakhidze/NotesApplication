//
//  UIViewExtension.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 05.11.24.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
