//
//  ViewController.swift
//  SeaFood
//
//  Created by merlin Moya on 2/15/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imaveView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
      imagePicker.sourceType = .camera //if you are testing the app using your iphone
       //imagePicker.sourceType = .photoLibrary //if you are using a simulator
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { imaveView.image = userPickedImage
        
            guard let ciimage = CIImage(image: userPickedImage) else
            {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
        try! handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
}

