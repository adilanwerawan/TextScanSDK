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
    
    override init() {
        // Handling the VNRequest to get the text from image
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: textResult)
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
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
        controller.dismiss(animated: true)
    }
    
    // Function to be called from the class to get result
    public func getScannedText(onView: UIViewController,resultHandler:@escaping TextReconginitionResult){
        // Use VisionKit to scan business cards
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        onView.present(documentCameraViewController, animated: true, completion: nil)
        self.textResult = resultHandler
    }
}

