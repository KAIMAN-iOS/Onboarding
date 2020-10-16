//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 16/10/2020.
//

import UIKit
import Onboarding
import FontExtension

class ViewController: UIViewController {
    lazy var data: [OnboardingData] = [
        self.data(title: "Request a ride",
                  message: "Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla.",
                  imageName: "Slide1"),
        self.data(title: "Vehicle selection",
                  message: "Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla.",
                  imageName: "Slide2"),
        self.data(title: "Live ride tracking",
                  message: "Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla.",
                  imageName: "Slide3"),
        self.data(title: "Trip sharing",
                  message: "Nulla vitae elit libero, a pharetra augue. Donec ullamcorper nulla non metus auctor fringilla.",
                  imageName: "Slide4"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showOnboard()
    }
    
    @IBAction func showOnboard() {
        let ctrl = OnboardingController.create()
        ctrl.load(data)
        ctrl.doneCompletion = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        present(ctrl, animated: true, completion: {
        })
    }

    private func data(title: String, message: String, imageName: String) -> OnboardingData {
        OnboardingData(title: title,
                       message: message,
                       image: UIImage(named: imageName),
                       textColor: #colorLiteral(red: 0.1234303191, green: 0.1703599989, blue: 0.2791167498, alpha: 1),
                       titleFont: FontType.bigTitle,
                       messageFont: FontType.default)
    }

}

