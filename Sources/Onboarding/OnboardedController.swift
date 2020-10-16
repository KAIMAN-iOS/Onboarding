//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import FontExtension
import LabelExtension

class OnboardedController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func configure(_ data: OnboardingData) {
        titleLabel.set(text: data.title, for: data.font, textColor: data.textColor)
        messageLabel.set(text: data.message, for: data.font, textColor: data.textColor)
        image.image = data.image
    }
}
