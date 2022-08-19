//
//  ViewController.swift
//  Instagrid
//
//  Created by Elodie Gage on 26/07/2022.
//


import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var layoutView: LayoutView!
    @IBOutlet weak var layoutOptions: LayoutOptionView!
    private var selectedButton: UIButton?
    
    ///  Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        orientationChange()
        setDefaultStyle()
        createSwipeUpWithActionAndDirection()
        createSwipeLeftWithActionAndDirection()

       // Notification observer when view's loaded
        let name = Notification.Name(rawValue: "LayoutStyle")
        NotificationCenter.default.addObserver(self, selector: #selector(selectLayout(_:)), name: name, object: nil)
    }
    
    ///  User Permission ask on launch
    /// - Parameter animated: Notifies the view controller that its view was added to a view hierarchy. in this case a permission notification alert
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PHPhotoLibrary.requestAuthorization { (status) in
        }
    }

    /// Notifies the container that the size of its view is about to change
    /// - Parameters:
    ///   - size: devices landscape or portrait
    ///   - coordinator: UIViewController
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        orientationChange()
    }
    
    /// picker creation, gesture controller for tapped action
    /// - Parameter sender: UiButton
    @IBAction func buttonTapped(_ sender: UIButton) {
        //whanever user wants to go to the picture library, we check the auth
        if checkAuthorizationStatus() == true {
        // selected button takes the sender as its value:
        selectedButton = sender
        // create a UIImagePickerController:
        let picker = UIImagePickerController()
        // declare ViewController as picker's delegate :
        picker.delegate = self
        // display picker:
        self.present(picker, animated: true)
        }
    }

    // called when notification is observed, allows to display the correct layout from choosen style with a switch:
    /// Whenever notification appear, layout are choose to be displayed with the switch
    /// - Parameter notification: userInfo 'Style' (reffers to enum)
    @objc private func selectLayout(_ notification: Notification) {
        if let style = notification.userInfo?["style"] as? String {
            switch style {
            case "layout1":
                layoutView.setStyle(.layout1)
            case "layout2":
                layoutView.setStyle(.layout2)
            case "layout3":
                layoutView.setStyle(.layout3)
            default:
                return
            }
        }
    }
    
    /// Default Style used for natural behaviour on both LayoutView and LayoutOption (frames under)
    private func setDefaultStyle() {
        layoutView.setStyle(.layout1)
        layoutOptions?.setLayoutStyle(style: .layout1)
    }
    
    /// if Device orientation changes swipeLabel  and arrowImage icon are modify, i'ts reffers to the actual orientation device
    private func orientationChange() {
        if UIDevice.current.orientation.isLandscape {
            arrowImage.image = #imageLiteral(resourceName: "Arrow Left")
            swipeLabel.text = "Swipe left to share"
        }
        else {
            arrowImage.image = #imageLiteral(resourceName: "Arrow Up")
            swipeLabel.text = "Swipe up to share"
        }
    }
    
    /// shareImage func:    after checking auth,
    private func shareImage() {
        // check authorization to save images:
        guard checkAuthorizationStatus() else {
            reverseTranslation()
            reverseTranslationLabel()
            reverseTranslationArrowImage()
            return
        }
        // save in an array what should be exported:
        let activityItems = [exportImage()]
        // instanciate UIActivityViewController with items to export in its parameters, appilcationActivities is nil to display default option that can share images:
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        // add in a closure the return animation of the view,label,image to its initial position:
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            self.reverseTranslation()
            self.reverseTranslationLabel()
            self.reverseTranslationArrowImage()
            self.successAlert()
        }
        // and display:
        self.present(activityController, animated: true)
    }
    
    /// Verification wich authorization status is actually stated with  switch
    /// - Returns: bool
    private func checkAuthorizationStatus() -> Bool {
        //PHPhotoLibrary is An object that manages access and changes to the user’s photo library.
        let readWriteStatus = PHPhotoLibrary.authorizationStatus()
        switch readWriteStatus {
        case .notDetermined:
            accessAlert()
            return false
        case .authorized:
            return true
        default:
            needAccessAlert()
            return false
        }
    }

    /// Image export: takes an LayoutView, transform image by drawing and Renders a snapshot of LayoutView
    /// - Returns: image (final image ready to be shared)
    private func exportImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: layoutView.bounds.size)
        let image = renderer.image { ctx in
            layoutView.drawHierarchy(in: layoutView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    /// Gesture SwipeUp UISwipeGestureRecognizer
    private func createSwipeUpWithActionAndDirection() {
        //  create gesture with selector on action:
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        // give swipe's direction:
        swipeUp.direction = .up
        // add gestureRecognizer to the Layoutview (main):
        layoutView.addGestureRecognizer(swipeUp)
    }
    
    /// Gesture SwipeLeft UISwipeGestureRecognizer
    private func createSwipeLeftWithActionAndDirection() {
        // create gesture with selector on action:
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        // give swipe's direction:
        swipeLeft.direction = .left
        // add gestureRecognizer to the Layoutview (main):
        layoutView.addGestureRecognizer(swipeLeft)
    }
    
    /// Animation when user swipe (swipe label and LayoutView go up then down when sharing is done)
    /// - Parameter sender: UISwipeGestureRecognizer
    @objc private func swipeUp(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait {
            UIView.animate(withDuration: 0.5) {
               // Calculs for translation on Y for both swipelabel,layoutView and arrow:
                let translationY = -(self.view.bounds.height/6 + self.layoutView.bounds.height/6)
                let translationYLabel = -(self.view.bounds.height/6 + self.swipeLabel.bounds.height/6)
                let translationYArrowImage = -(self.view.bounds.height/6 + self.arrowImage.bounds.height/6)
                // Init the translation:
                self.layoutView.transform = CGAffineTransform(translationX: 0, y: translationY)
                self.swipeLabel.transform = CGAffineTransform(translationX: 0, y: translationYLabel)
                self.arrowImage.transform = CGAffineTransform(translationX: 0, y: translationYArrowImage)
            } completion: { (success) in
                self.shareImage()
            }
        }
    }
    
    /// same animation above now the action is available if the device is in landscape orientation
    /// - Parameter sender: UISwipeGestureRecognizer
    @objc private func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.5) {
                ///  Calculs for translation on X for both swipelabel and layoutView:
                let translationX = -(self.view.bounds.width/2 + self.layoutView.bounds.width/2)
                let translationXLabel = -(self.view.bounds.width/2 + self.swipeLabel.bounds.width/2)
                let translationXArrowImage = -(self.view.bounds.width/2 + self.swipeLabel.bounds.width/2)
                // Init the translation:
                self.layoutView.transform = CGAffineTransform(translationX: translationX, y: 0)
                self.swipeLabel.transform = CGAffineTransform(translationX: translationXLabel, y: 0)
                self.arrowImage.transform = CGAffineTransform(translationX: translationXArrowImage, y: 0)
            } completion: { (success) in
                self.shareImage()
            }
        }
    }

    // give the view its initial position :
    private func reverseTranslation() {
        UIView.animate(withDuration: 0.5) {
            self.layoutView.transform = .identity
        }
    }
    // give the swipeLabel its initial position :
    private func reverseTranslationLabel() {
        UIView.animate(withDuration: 0.5) {
            self.swipeLabel.transform = .identity
        }
    }
    // give the swipeLabel its initial position :
    private func reverseTranslationArrowImage() {
        UIView.animate(withDuration: 0.5) {
            self.arrowImage.transform = .identity
        }
    }
    
    /// Notification when share picture is done (UIAlertController) actually only when the action is done on interface
    private func successAlert() {
        let alert = UIAlertController(title: "Picture sent", message: "Amazing job,Picasso !", preferredStyle: .alert)
        let action = UIAlertAction(title: "Great !", style: .default, handler: nil)
        alert.addAction(action)
        // present is used whenever the notification/action is completed in program so user have an alert of what just happend
        present(alert, animated: true, completion: nil)
    }
    
    /// Notification to acces the user gallery  (UIAlertController, PHPhotoLibrary)
    private func accessAlert() {
        let alertController = UIAlertController(title: "Instagrid Notification", message: "We need access to your gallery", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Agree", style: .default, handler: { (action) in
            PHPhotoLibrary.requestAuthorization { (status) in }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    /// If User denied the acces the first time ask him to do go to the settings and change the access
    private func needAccessAlert() {
        //notification alert:
        let alertController = UIAlertController(title: "Authorization denied", message: "Go to Settings > Instagrid and grant access to your pictures to continue", preferredStyle: .alert)
        //alert action possibility -> go to settings using URL
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            // Url settings provides the action: moving to app's settings screen
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
} // end of class ViewController \\

// extension is an ability to add new type on this class. Retroactive modeling
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// imagePickerController Tells the delegate that the user picked a still image
    /// - Parameters:
    ///   - picker: UIImagePickerController
    ///   - info:UIImagePickerController: view controller that manages the system interfaces for choosing items from the user's media library...
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
        // check and unwrap the image chosen by the user:
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        // change the content mode of the button's image: scale the content to fill the size of the view
        selectedButton?.imageView?.contentMode = .scaleAspectFill
        // set chosen image in button's image:
        selectedButton?.setImage(image, for: .normal)
        // then selectedButton value is passed as nil to avoid mistakes (it's default state of the button):
        selectedButton = nil
        // dissmiss th picker:
        picker.dismiss(animated: true)
    }
}
