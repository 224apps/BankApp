//
//  OnboardingContainerViewController.swift
//  BankApp
//
//  Created by Abdoulaye Diallo on 12/20/22.
//

import UIKit

protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

class OnboardingContainerViewController: UIViewController {
    
    weak var delegate: OnboardingContainerViewControllerDelegate?
    
    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    
    var currentVC: UIViewController {
        didSet {
            guard let index = pages.firstIndex(of: currentVC) else { return }
            nextButton.isHidden = index == pages.count - 1
            backButton.isHidden = index == 0
            doneButton.isHidden = !(index == pages.count - 1)
        }
    }
    
    let closeButton =  UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingViewController(imageName: "home1",
                                             titleText: "BankApp is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989.")
        let page2 = OnboardingViewController(imageName: "home2",
                                             titleText: "BankApp is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989.")
        let page3 = OnboardingViewController(imageName: "home3",
                                             titleText: "BankApp is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989.")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        style()
        layout()
    }
    
    //MARK: - Private methods
    
    private func setUp(){
        view.backgroundColor = .systemPurple
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
        ])
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }
    
    private func style(){
        //NextButton
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: [])
        nextButton.titleLabel?.textColor = .black
        nextButton.addTarget(self, action: #selector(nextTapped), for: .primaryActionTriggered)
        
        //BackButton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: [])
        backButton.titleLabel?.textColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .primaryActionTriggered)
        
        //DoneButton
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: [])
        doneButton.titleLabel?.textColor = .black
        doneButton.addTarget(self, action: #selector(doneTapped), for: .primaryActionTriggered)
        
        //closeButton
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.titleLabel?.textColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
    }

    
    private func layout(){
        
        //nextButton
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 2)
               ])
        
        
        //backButton
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 4)
               ])
        
        
        //closeButton
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
                   closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
                   closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
               ])
        
        //DoneButton
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: doneButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 2)
               ])
    }
    
}
//MARK: - DataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }
    
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 > 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1  < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}


//MARK: - Actions

extension OnboardingContainerViewController {
    @objc private func nextTapped(){
        guard let nextVC = getNextViewController(from: currentVC) else { return  }
        pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func backTapped(){
        guard let previousVC = getPreviousViewController(from: currentVC) else { return  }
        pageViewController.setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
    }
    @objc private func closeTapped(){
        delegate?.didFinishOnboarding()
    }
    @objc private func doneTapped(){
        delegate?.didFinishOnboarding()
    }

}
