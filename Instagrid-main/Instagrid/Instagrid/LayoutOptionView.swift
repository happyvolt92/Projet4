//
//  ViewController.swift
//  Instagrid
//
//  Created by Elodie Gage on 26/07/2022.
//


import UIKit

/// enum for the 3 available display of frames = Layout
enum Style {
    case layout1, layout2, layout3
}

class LayoutOptionView: UIView {
    @IBOutlet var layoutOneButton: UIButton!
    @IBOutlet var layoutOneSelected: UIImageView!
    @IBOutlet var layoutTwoButton: UIButton!
    @IBOutlet var layoutTwoSelected: UIImageView!
    @IBOutlet var layoutThreeButton: UIButton!
    @IBOutlet var layoutThreeSelected: UIImageView!

    
    /// Notifications are created and sent  whenever func are call
    /// - Parameters:
    ///   - key: Keys(type)
    ///   - value: Keys (type)
    private func createAndPostNotification(key: Keys, value: Keys) {
        let name = Notification.Name(rawValue: Keys.name.rawValue)
        let notification = Notification(name: name, object: nil, userInfo: [key.rawValue: value.rawValue])
        NotificationCenter.default.post(notification)
    }
    
    /// enum of words keys to call it later
    private enum Keys: String {
        case layout1 = "layout1"
        case layout2 = "layout2"
        case layout3 = "layout3"
        case style = "style"
        case name = "LayoutStyle"
    }

    /// Notify app when Switch is tapped between displays using key and value, style of the differents layout (small frames on bottom)
    /// - Parameter sender: UIBUTTON
    @IBAction func selectLayout(_ sender: UIButton) {
        switch sender {
        case layoutOneButton:
            createAndPostNotification(key: .style, value: .layout1)
            setLayoutStyle(style: .layout1)
        case layoutTwoButton:
            createAndPostNotification(key: .style, value: .layout2)
            setLayoutStyle(style: .layout2)
        case layoutThreeButton:
            createAndPostNotification(key: .style, value: .layout3)
            setLayoutStyle(style: .layout3)
        default:
            break
        }
    }
    
    /// Behaviour of the windows for the differents frames on app's bottom (visibility changes when one is tapped)
    /// - Parameter style: Style's Type, reffers to enum Style in LayoutView
    func setLayoutStyle(style: Style) {
        switch style {
        case .layout1:
            layoutOneSelected.isHidden = false
            layoutTwoSelected.isHidden = true
            layoutThreeSelected.isHidden = true
        case .layout2:
            layoutTwoSelected.isHidden = false
            layoutOneSelected.isHidden = true
            layoutThreeSelected.isHidden = true
        case .layout3:
            layoutThreeSelected.isHidden = false
            layoutTwoSelected.isHidden = true
            layoutOneSelected.isHidden = true
        }
    }

}
