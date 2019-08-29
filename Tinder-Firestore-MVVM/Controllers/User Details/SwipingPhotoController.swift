//
//  SwipingPhotoController.swift
//  Tinder-Firestore-MVVM
//
//  Created by iOS dev on 29/8/19.
//  Copyright © 2019 iOS dev. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        
        let controllers = [redVC]
        
        setViewControllers(controllers, direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return PhotoController(image: #imageLiteral(resourceName: "dismiss_down_arrow"))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return PhotoController(image: #imageLiteral(resourceName: "boost_circle"))
    }
    
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.fillSuperView()
    }
}
