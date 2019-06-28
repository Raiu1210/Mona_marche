//
//  ShoppingViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController, UITabBarDelegate {
    let cart_img = UIImage(named: "./cart.png")
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.cyan
        self.tabBarItem = UITabBarItem(title: "買いたい", image: cart_img, tag: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        create_how_to_use()
//        create_tab_bar()
    }
    
    
    
    
    
}

