//
//  Sizing.swift
//  NotesApp
//
//  Created by Tamuna Kakhidze on 05.11.24.
//
import Foundation

struct Sizing {
    // MARK: - Button Sizes and Styles
    struct Button {
        static let backButtonCornerRadius: CGFloat = 15
        static let cancelButtonCornerRadius: CGFloat = 5
        static let deleteButtonCornerRadius: CGFloat = 5
        static let deleteButtonSize: CGFloat = 34
        static let cellDeleteButtonCornerRadius: CGFloat = 15
        static let cellDeleteButtonHeight: CGFloat = 34
        static let cellDeleteButtonWidth: CGFloat = 34
    }
    
    // MARK: - Alert Sizing
    struct Alert {
        static let cornerRadius: CGFloat = 20
        static let stackViewSpacing: CGFloat = 20
        static let messageFontSize: CGFloat = 20
        static let iconTopAnchor: CGFloat = 44
        static let messageTopAnchor: CGFloat = 10
        static let messageWidth: CGFloat = 262
        static let messageHeight: CGFloat = 48
        static let buttonsWidth: CGFloat = 112
        static let buttonsStackViewTopAnchor: CGFloat = 24
    }
    
    // MARK: - Note Cell Sizing
    struct NoteCell {
        static let cornerRadius: CGFloat = 10
        static let titleHeight: CGFloat = 67
        static let titleWidth: CGFloat = 290
        static let titleNumberOfLines: Int = 2
        static let titleFontSize: CGFloat = 25
        static let deleteButtonAnchor: CGFloat = -12
    }
    
    // MARK: - AddNoteVC Sizing
    struct AddNoteVC {
        static let backButtonWidth: CGFloat = 44
        static let backButtonHeight: CGFloat = 44
        static let titleTopAnchor: CGFloat = 141
        static let titleWidth: CGFloat = 360
        static let titleFontSize: CGFloat = 35
        static let descriptionWidth: CGFloat = 360
        static let descriptionHeight: CGFloat = 450
        static let descriptionFontSize: CGFloat = 22
        
        static let saveButtonBottomAnchor: CGFloat = -30
        static let saveButtonTrailingAnchor: CGFloat = -25
    }
    
    // MARK: - MainVC Sizing
    struct MainVC {
        static let tableViewTopAnchor: CGFloat = 131
        static let tableViewBottomAnchor: CGFloat = -139
        static let tableViewLeadingAnchor: CGFloat = 24
        static let tableViewTrailingAnchor: CGFloat = -25
        static let tableViewRowHeight: CGFloat = 110
        
        static let plusButtonBottomAnchor: CGFloat = -30
        static let plusButtonTrailingAnchor: CGFloat = -25
        static let plusButtonWidth: CGFloat = 70
        static let plusButtonHeight: CGFloat = 70
        static let plusButtonCornerRadius: CGFloat = plusButtonWidth / 2
        static let plusButtonShadowRadius: CGFloat = 10
        static let plusButtonShadowOpacity: Float = 1
        static let plusButtonShadowWidth: CGFloat = 2.0
        static let plusButtonShadowHeight: CGFloat = 2.0
        static let heightForFooterInSection: CGFloat = 20
        static let numberOfRowsInSection: Int = 1
    }
}
