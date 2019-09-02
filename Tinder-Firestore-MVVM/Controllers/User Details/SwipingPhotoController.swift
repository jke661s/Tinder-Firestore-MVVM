//
//  SwipingPhotoController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 29/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // UI Components
    fileprivate var controllers = [UIViewController]()
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    // View Models
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
            
            setupBarViews()
        }
    }
    // Configuration
    
    fileprivate var isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentController}) {
            
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            
            if gesture.location(in: self.view).x > self.view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false, completion: nil)
                
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let prevIndex = max(index - 1, 0)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .reverse, animated: false, completion: nil)
                barStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
            
            
        }
        
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            guard let v = v as? UIScrollView else { return }
            v.isScrollEnabled = false
        }
    }
    
    fileprivate func setupBarViews() {
        barStackView.axis = .horizontal
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = barDeselectedColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        var paddingTop: CGFloat = 8
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barStackView)
        barStackView.setConstraint(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        guard let index = controllers.firstIndex(where: {$0 == currentPhotoController}) else { return }
        barStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
        barStackView.arrangedSubviews[index].backgroundColor = .white
    }
    
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.fillSuperView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
