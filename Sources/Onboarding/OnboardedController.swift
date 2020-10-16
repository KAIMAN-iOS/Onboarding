//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import FontExtension
import LabelExtension

private enum DefaultFont: Fontable {
    case title, message
    
    var font: UIFont {
        switch self {
        case .title: return Font.style(.title1)
        case .message: return Font.style(.body)
        }
    }
}

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
        titleLabel.set(text: data.title, for: data.titleFont ?? DefaultFont.title, textColor: data.textColor)
        messageLabel.set(text: data.message, for: data.messageFont ?? DefaultFont.message, textColor: data.textColor)
        image.image = data.image
    }
}
