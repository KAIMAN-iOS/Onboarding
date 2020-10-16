//
//  File.swift
//  
//
//  Created by GG on 16/10/2020.
//

import UIKit
import FontExtension
import UIViewControllerExtension
import UIViewExtension

public struct OnboardingData {
    let title: String
    let message: String
    let image: UIImage
    let textColor: UIColor
    let font: Fontable
}

final class OnboardingController: UIViewController {
    static func create() -> OnboardingController {
        return OnboardingController.loadFromStoryboard(storyboard: "Onboarding")
    }
    
    var pageController: UIPageViewController!
    @IBOutlet public weak var pageContainer: UIView!  {
        didSet {
            pageContainer.round(corners: [.bottomLeft, .bottomRight], radius: 20.0)
            pageContainer.clipsToBounds = true
        }
    }

    @IBOutlet public weak var pageControl: UIPageControl!
    @IBOutlet public weak var nextButton: UIButton!  {
        didSet {
            nextButton.layer.cornerRadius = nextButton.frame.midY
        }
    }

    @IBOutlet public weak var skipButton: UIButton!
    var doneCompletion: (() -> Void)? = nil
    
    private var onboardingData: [OnboardingData] = []
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pager = children.compactMap({ $0 as? UIPageViewController }).first else {
            fatalError("No page controller found")
        }
        pageController = pager
        pageController.dataSource = self
        
        guard let first = onboardingData.first else {
            return
        }
        pageController.setViewControllers([controller(for: first)],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)
        addGesture(for: .left)
        addGesture(for: .right)
    }
    
    func addGesture(for direction: UISwipeGestureRecognizer.Direction) {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        gesture.direction = direction
        view.addGestureRecognizer(gesture)
    }
    
    public func load(_ data: [OnboardingData]) {
        onboardingData = data
        pageControl.numberOfPages = data.count
        pageControl.currentPage = 0
    }
    
    @objc func swipe(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        switch gesture.direction {
        case .left: showNextController()
        case .right: showPreviousController()
        default: ()
        }
    }
    
    func controller(for data: OnboardingData) -> OnboardedController {
        let ctrl: OnboardedController = OnboardedController.loadFromNib()
        ctrl.configure(data)
        return ctrl
    }
    
    @IBAction func pageControlSelected() {
        if pageControl.currentPage < currentIndex {
            showPreviousController()
        } else {
            showNextController()
        }
    }
    
    @IBAction func next() {
        showNextController()
    }
    
    @IBAction func skip() {
        doneCompletion?()
    }
    
    @discardableResult
    func showNextController() -> UIViewController? {
        guard currentIndex > 0, currentIndex + 1 < onboardingData.count else { return nil }
        currentIndex += 1
        pageControl.currentPage += 1
        return controller(for: onboardingData[currentIndex])
    }
    
    @discardableResult
    func showPreviousController() -> UIViewController? {
        guard currentIndex > 0, (currentIndex - 1) > 0 else { return nil }
        currentIndex -= 1
        pageControl.currentPage -= 1
        return controller(for: onboardingData[currentIndex])
    }
}

extension OnboardingController: UIPageViewControllerDelegate {
    
}

extension OnboardingController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        showPreviousController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        showNextController()
    }
}
