//
//  ViewController.swift
//  WhatFlower
//
//  Created by Shubham Mishra on 14/04/21.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

struct Parameters: Encodable {
    let format: String
    let action: String
    let prop: String
    let exintro: String
    let explaintext: String
    var titles: String
    let indexpageids: String
    let redirects: String
}

//let wikipediaURl = "https://en.wikipedia.org/w/api.php"
//

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    private let imagePicker = UIImagePickerController()
    let url = "https://en.wikipedia.org/w/api.php"
    var parameters = Parameters(format: "json", action: "query", prop: "extracts", exintro: "", explaintext: "", titles: "", indexpageids: "", redirects: "1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        navigationItem.title = "What Flower"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let userCapturedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userCapturedImage
            guard let image = CIImage(image: userCapturedImage) else {
                fatalError("Could not convert to ciimage")
            }
            detect(image)
        }
    }
    
    func detect(_ image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: MLModelConfiguration()).model) else {
            fatalError("Could loading model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let result = results.first {
                print(result)
                self.navigationItem.title = result.identifier.capitalized
                self.parameters.titles = result.identifier.capitalized
                self.wikiRequest(flowerName: result.identifier.capitalized)
            } else {
                self.navigationItem.title = "Not Detected"
                self.textView.text = ""
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func wikiRequest(flowerName: String) {
        
        AF.request(self.url, method: .get, parameters: self.parameters).responseJSON { (response) in
            print("Hi")
            if let success = try? response.result.get() {
                let json = (JSON(success))
                if let pageid = json["query"]["pageids"][0].string {
                    self.textView.text = json["query"]["pages"][pageid]["extract"].string
                }
            }
        }
        
    }

    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func resetPressed(_ sender: UIBarButtonItem) {
        imageView.image = .none
        textView.text = .none
        navigationItem.title = "What Flower"
    }
}

