//
//  ShoppingViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsListViewController: UIViewController, UITabBarDelegate {
    let cart_img = UIImage(named: "./cart.png")
    let data_server = "http://zihankimap.work/mona//goods_list"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let scrollView = UIScrollView()
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    var refreshControl:UIRefreshControl!
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
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
        
        self.title = "商品リスト"
        self.get_data_from_server(url: self.data_server)
    }
    
    
    internal func get_data_from_server(url:String){
        let url = URL(string: url)!
        print("URL : \(url)")
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in if error == nil, let data = data, let response = response as? HTTPURLResponse {
            let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
//            self.save_jsonString_data(jsonString: jsonString)
//            self.load_jsonString_and_createView(jsonString: jsonString)
            }
        }.resume()
    }
    
    
}

