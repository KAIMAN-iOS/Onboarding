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
import SnapKit

class OnboardedController: UIViewController {
    lazy var titleLabel: UILabel = {
        UILabel()
    }()
    lazy var messageLabel: UILabel = {
        UILabel()
    }()
    @IBOutlet weak var image: UIImageView!
    private var data: OnboardingData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeVisualEffect()
    }
    
    
    func initializeVisualEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView()
        blurEffectView.effect = blurEffect
        image.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        vibrancyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 8
        vibrancyView.contentView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(20)
            $0.bottom.right.equalToSuperview().offset(-20)
        }
        messageLabel.numberOfLines = 0
    }
    
    func configure(_ data: OnboardingData) {
        self.data = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if titleLabel.superview == nil {
            initializeVisualEffect()
        }
        titleLabel.set(text: data.title, for: data.titleFont ?? .title1, traits: [.traitBold], textColor: data.textColor)
        messageLabel.set(text: data.message, for: data.messageFont ?? .body, textColor: data.textColor)
        image.image = data.image
    }
}
