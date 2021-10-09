//
//  ViewController.swift
//  UIKit-CoreImage
//
//  Created by Manish on 09/10/21.
//

import UIKit

// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW29
//
class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterNameTextField: UITextField!
    @IBOutlet var intensityLabel: UILabel!
    private var intensityStepperValue: Double = 0
    
    private let originalImage = UIImage(named: "MrBean")
    private let context = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.intensityLabel.text = "Filter Intensity : 0"
        
    }
    @IBAction func didTapStepper(_ sender: UIStepper) {
        self.intensityStepperValue = sender.value
        
        self.intensityLabel.text = "Filter Intensity : \(String(format: "%.2f", sender.value))"
    }
    
    @IBAction func didTapApplyFilterButton(_ sender: UIButton) {
        
        if let ciImage = CIImage(image: originalImage!),
           let filterName = filterNameTextField.text,
           !filterName.isEmpty,
           let ciFilter = CIFilter(name: filterName) {
            
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // For some filters intensity is not required
            // don't set unwanted value to avoid run-time crash
            if self.intensityStepperValue > 0 {
                ciFilter.setValue(intensityStepperValue, forKey: kCIInputIntensityKey)
            }
            
            if let processedImaageData = ciFilter.outputImage,
               let outputImage = context.createCGImage(processedImaageData, from: ciImage.extent){
                self.imageView.image = UIImage(cgImage: outputImage)
            } else {
                assertionFailure()
            }
            
        } else {
            assertionFailure()
        }
        
    }
}

