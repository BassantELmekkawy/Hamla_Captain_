//
//  ShowPhotoActionSheet.swift
//  Hamla
//
//  Created by Bassant on 04/04/2024.
//

import Foundation
import UIKit
import PhotosUI

protocol PhotoActionSheetDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class PhotoActionSheet: NSObject {
    
    weak var delegate: PhotoActionSheetDelegate?
    private weak var viewController: UIViewController?
    
    func openCamera() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        viewController?.present(pickerController, animated: true)
    }
    
    func configureImagePicker(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        viewController?.present(pickerViewController, animated: true)
    }
    
    func showActionSheet(from vc: UIViewController) {
        self.viewController = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        actionSheet.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.configureImagePicker()
        }
        actionSheet.addAction(photoLibraryAction)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        vc.present(actionSheet, animated: true)
    }
}

extension PhotoActionSheet: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            delegate?.didSelectImage(image)
        }
    }
}

extension PhotoActionSheet: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider{
          
            if itemprovider.canLoadObject(ofClass: UIImage.self){
               
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.delegate?.didSelectImage(selectedImage)
                        }
                    }
                }
            }
            
        }
    }
}
