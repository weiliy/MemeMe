//
//  ViewController.swift
//  MemeMe
//
//  Created by Weili Yi on 2024/1/3.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageBoardView: UIView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickView.contentMode = .scaleAspectFill

        topTextField.delegate = self
        topTextField.textAlignment = .center
        
        bottomTextField.delegate = self
        bottomTextField.textAlignment = .center
        
        topTextField.text = "TOP MEME!!!"
        bottomTextField.text = "BOTTOM MEME!!!"
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(.gray),
            NSAttributedString.Key.strokeColor: UIColor(.red),
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  2,
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imagePickView.image !== nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAImageFromAlbum(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = .photoLibrary
        present(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func pickAImageFromCamera(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = .camera
        present(pickImageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickView.image = image
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("user cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if (bottomTextField.isEditing) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func generateMemedImage() -> UIImage {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        
        UIGraphicsBeginImageContext(self.imageBoardView.bounds.size)
        imageBoardView.drawHierarchy(in: self.imageBoardView.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    @IBAction func save(_ sender: Any) {
        let memedImage = generateMemedImage()
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickView.image!, memedImage: memedImage)
        imagePickView.image = memedImage
    }
}

