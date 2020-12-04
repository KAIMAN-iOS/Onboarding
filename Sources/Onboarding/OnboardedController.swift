//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import FontExtension
import LabelExtension
import Ampersand

class OnboardedController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    private var data: OnboardingData!
    
    func configure(_ data: OnboardingData) {
        self.data = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.set(text: data.title, for: data.titleFont ?? .title1, textColor: data.textColor)
        messageLabel.set(text: data.message, for: data.messageFont ?? .body, textColor: data.textColor)
        image.image = data.image
    }
}
