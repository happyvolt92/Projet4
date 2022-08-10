//
//  ViewController.swift
//  Instagrid
//
//  Created by Elodie Gage on 26/07/2022.
//


import UIKit
import Foundation


class LayoutView: UIView {

    // MARK: - Outlets

    @IBOutlet var layout1: UIView!
    @IBOutlet var layout2: UIView!
    @IBOutlet var layout3: UIView!

    // MARK: - Property

    var style: Style = .layout1 {
        didSet {
            setStyle(style)
        }
    }

    // MARK: - Function
    
    func setStyle(_ style: Style) {
        switch style {
        case .layout1:
            layout1.isHidden = false
            layout2.isHidden = true
            layout3.isHidden = true
        case .layout2:
            layout1.isHidden = true
            layout2.isHidden = false
            layout3.isHidden = true
        case .layout3:
            layout1.isHidden = true
            layout2.isHidden = true
            layout3.isHidden = false
        }
    }
}
