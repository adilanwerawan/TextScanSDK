//
//  ViewController.swift
//  scantext
//
//  Created by MacBook on 31/03/2022.
//

import UIKit
import VisionKit
import Vision

// Defined typealias of text recognition result for ease
public typealias TextReconginitionResult = (_ request: VNRequest?, _ error: Error?) -> Void

public class TextScanner: NSObject, VNDocumentCameraViewControllerDelegate {
    
    // Using vision frame work for text recognition
    var textRecognitionRequest = VNRecognizeTextRequest()
    // Handler to get the data from this text recognition class
    var textResult:TextReconginitionResult!
    var delegate:CameraTextResultDelegate?
    
    public override init() {
        // Handling the VNRequest to get the text from image
        super.init()
        
    }
    
    // Delegate method of VNDocumentCameraViewControllerDelegate to get data from image
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
//        controller.dismiss(animated: true)
    }
    
    // Function to be called from the class to get result
    /// Pass the parent view here in presentOnView from which you need to present scanner view,
    /// Pass the view as resultView on which you have to show the results.
    public func getScannedText(presentOnView: UIViewController, resultView:UITextView,callBackDelegate:CameraTextResultDelegate){
        // Use VisionKit to scan business cards
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        presentOnView.present(documentCameraViewController, animated: true, completion: nil)
        self.delegate = callBackDelegate
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: {  request, error in
            DispatchQueue.main.async {
                var recognizedText = ""
                if let results = request.results, !results.isEmpty {
                    if let requestResults = request.results as? [VNRecognizedTextObservation] {
                        recognizedText = ""
                        for observation in requestResults {
                            guard let candidiate = observation.topCandidates(1).first else { return }
                            recognizedText += candidiate.string
                            recognizedText += "\n"
                        }
                        resultView.text = recognizedText
                    }
                    documentCameraViewController.dismiss(animated: true)
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
    }
}

