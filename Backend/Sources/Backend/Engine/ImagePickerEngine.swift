//
//  ImagePickerEngine.swift
//  
//
//  Created by Kevin Laminto on 14/9/20.
//

import Foundation
import UIKit

public class ImagePickerEngine: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var picker = UIImagePickerController()
    private var viewController: UIViewController?
    private var pickImageCallback: ((UIImage) -> Void)?
    
    public static let shared = ImagePickerEngine()
    
    private override init() {
        super.init()
    }
    
    public func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> Void)) {
        pickImageCallback = callback
        self.viewController = viewController
        
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
    
    @objc private func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}
