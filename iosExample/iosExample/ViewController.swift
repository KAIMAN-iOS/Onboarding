//
//  ViewController.swift
//  iosExample
//
//  Created by GG on 16/10/2020.
//

import UIKit
import Onboarding
import FontExtension
import ATAConfiguration

class Configuration: ATAConfiguration {
    var logo: UIImage? { nil }
    var palette: Palettable { Palette() }
}

class Palette: Palettable {
    var primary: UIColor { #colorLiteral(red: 0.8604696393, green: 0, blue: 0.1966537535, alpha: 1) }
    var secondary: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    var mainTexts: UIColor { #colorLiteral(red: 0.1879811585, green: 0.1879865527, blue: 0.1879836619, alpha: 1) }
    
    var secondaryTexts: UIColor { #colorLiteral(red: 0.1565656662, green: 0.1736218631, blue: 0.2080874145, alpha: 1) }
    
    var textOnPrimary: UIColor { #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    
    var inactive: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    var placeholder: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    var lightGray: UIColor { #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
    
    
}

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
        let ctrl = OnboardingController.create(with: self, configuration: Configuration())
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
                       titleFont: .largeTitle,
                       messageFont: .body)
    }
}

extension ViewController: OnboardingDelegate {
    func titleForNextButton(at index: Int) -> String? {
        return index == 3 ? "C'est parti" : "Next"
    }
}
