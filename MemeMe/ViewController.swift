//
//  ViewController.swift
//  MemeMe
//
//  Created by Weili Yi on 2024/1/3.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imagePickView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pickAImageBtn(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        present(pickImageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("user cancelled")
        dismiss(animated: true, completion: nil)
    }
}

