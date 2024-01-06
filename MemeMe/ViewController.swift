//
//  ViewController.swift
//  MemeMe
//
//  Created by Weili Yi on 2024/1/3.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickView.contentMode = .scaleAspectFill

        topTextField.textAlignment = .center
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
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("user cancelled")
        dismiss(animated: true, completion: nil)
    }
}

