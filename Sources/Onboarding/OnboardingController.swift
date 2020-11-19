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
import ATAConfiguration

public struct OnboardingData {
    let title: String
    let message: String
    let image: UIImage?
    let textColor: UIColor
    let titleFont: Fontable?
    let messageFont: Fontable?
    
    public init(title: String,
                message: String,
                image: UIImage?,
                textColor: UIColor,
                titleFont: Fontable? = nil,
                messageFont: Fontable? = nil) {
        self.title = title
        self.message = message
        self.image = image
        self.textColor = textColor
        self.titleFont = titleFont
        self.messageFont = messageFont
    }
}

public protocol OnboardingDelegate: class {
    func titleForNextButton(at index: Int) -> String?
}

final public class OnboardingController: UIViewController {
    static var configuration: ATAConfiguration!
    public static func create(with delegate: OnboardingDelegate? = nil, configuration: ATAConfiguration) -> OnboardingController {
        let ctrl: OnboardingController = UIStoryboard(name: "Onboarding", bundle: Bundle.module).instantiateInitialViewController() as! OnboardingController
        ctrl.delegate = delegate
        OnboardingController.configuration = configuration
        return ctrl
    }
    weak var delegate: OnboardingDelegate?
    @IBOutlet public weak var pageContainer: UIView!
    @IBOutlet public weak var pageControl: UIPageControl!
    @IBOutlet public weak var nextButton: UIButton!  {
        didSet {
            nextButton.layer.cornerRadius = nextButton.bounds.midY
        }
    }

    @IBOutlet public weak var skipButton: UIButton!  {
        didSet {
            skipButton.setTitle("SKIP".bundleLocale(), for: .normal)
        }
    }

    public var doneCompletion: (() -> Void)? = nil
    
    private var onboardingData: [OnboardingData] = []
    private var onboardingController: [UIViewController] = []
    private var currentIndex: Int = 0  {
        didSet {
            pageControl?.currentPage = currentIndex
        }
    }

    lazy var pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = OnboardingController.configuration.palette.mainTexts
        pageContainer.backgroundColor = OnboardingController.configuration.palette.primary
        
        pageContainer.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageController.dataSource = self
        pageController.delegate = self
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageContainer.round(corners: [.bottomLeft, .bottomRight], radius: 20.0)
        pageContainer.clipsToBounds = true
    }
    
    public func load(_ data: [OnboardingData]) {
        onboardingData.removeAll()
        onboardingController.removeAll()
        onboardingData = data
        onboardingController = onboardingData.compactMap({ controller(for: $0) })
        // for load pruposes
        guard pageControl != nil else { return }
        loadPages()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPages()
    }
    
    private func loadPages() {
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPage = 0
        
        guard let first = onboardingController.first else {
            return
        }
        pageController.setViewControllers([first],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)
        updateNextButton()
    }
    
    func controller(for data: OnboardingData) -> OnboardedController {
        let ctrl: OnboardedController = OnboardedController.init(nibName: "OnboardedController", bundle: Bundle.module)
        ctrl.configure(data)
        return ctrl
    }
    
    @IBAction func pageControlSelected() {
        show(controller: controller(at: pageControl.currentPage < currentIndex ? currentIndex - 1 : currentIndex + 1),
             direction: pageControl.currentPage < currentIndex ?.reverse : .forward)
    }
    
    @IBAction func next() {
        guard currentIndex < onboardingData.count - 1 else {
            doneCompletion?()
            return
        }
        show(controller: controller(at: currentIndex + 1), direction: .forward)
        currentIndex += 1
        updateNextButton()
    }
    
    @IBAction func skip() {
        doneCompletion?()
    }
    
    private func show(controller: UIViewController?, direction: UIPageViewController.NavigationDirection) {
        guard let controller = controller else { return }
        pageController.setViewControllers([controller],
                                          direction: direction,
                                          animated: true,
                                          completion: nil)
    }
    
    @discardableResult
    func controller(after controller: UIViewController) -> UIViewController? {
        guard let index = onboardingController.firstIndex(where: { $0 === controller }) else { return nil }
        print("-> \(currentIndex)")
        return self.controller(at: index + 1)
    }
    
    @discardableResult
    func controller(before controller: UIViewController) -> UIViewController? {
        guard let index = onboardingController.firstIndex(where: { $0 === controller }) else { return nil }
        print("-> \(currentIndex)")
        return self.controller(at: index - 1)
    }
    
    private func controller(at index: Int) -> UIViewController? {
        guard index >= 0, index < onboardingController.count else { return nil }
        return onboardingController[index]
    }
    
    func updateNextButton() {
        var title = currentIndex == onboardingData.count - 1 ? "LET'S GO".bundleLocale() : "NEXT".bundleLocale()
        if let delegateTitle = delegate?.titleForNextButton(at: currentIndex) {
            title = delegateTitle
        }
        // no transition is there is no text change
        guard title != nextButton.title(for: .normal) else { return }
        
        UIView.transition(with: self.nextButton, duration: 0.3,
                          options: currentIndex == self.onboardingData.count - 1 ? .transitionFlipFromLeft : .transitionFlipFromRight) { [weak self] in
            guard let self = self else { return }
            self.nextButton.setTitle(title, for: .normal)
            self.nextButton.backgroundColor = self.currentIndex == self.onboardingData.count - 1 ? #colorLiteral(red: 0.9877198339, green: 0.3950536847, blue: 0.3682359457, alpha: 1) : #colorLiteral(red: 0.996609509, green: 0.6680213809, blue: 0.006788168568, alpha: 1)
        } completion: { _ in
        }
    }
}

extension OnboardingController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let controller = pageController.viewControllers?.first,
              let index = onboardingController.firstIndex(where: { $0 === controller }) else {
            return
        }
        currentIndex = index
        updateNextButton()
    }
}

extension OnboardingController: UIPageViewControllerDataSource{
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        controller(before: viewController)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        controller(after: viewController)
    }
}

extension String {
    func bundleLocale() -> String {
        NSLocalizedString(self, bundle: .module, comment: self)
    }
}
