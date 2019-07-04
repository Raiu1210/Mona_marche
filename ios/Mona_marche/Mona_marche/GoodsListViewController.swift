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
    var image: UIImage?
    var refreshControl:UIRefreshControl!
    
    init () {
        super.init(nibName: nil, bundle: nil)
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
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        self.view.backgroundColor = UIColor.white
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
            self.load_jsonString_and_createView(jsonString: jsonString)
            }
        }.resume()
    }
    
    internal func load_jsonString_and_createView(jsonString:String) {
        DispatchQueue.main.async {
            do {
                self.appDelegate.goods_json_string = jsonString
                let json_Data: Data =  jsonString.data(using: String.Encoding.utf8)!
                let parsed_data = try JSON(data: json_Data)
                let num_of_Q = parsed_data.count
                self.create_view(num_of_Q: num_of_Q)
                print(num_of_Q)
                for i in 0 ..< parsed_data.count
                {
                    let id = parsed_data[i]["id"].stringValue
                    let title = parsed_data[i]["title"].stringValue
                    let image_path = parsed_data[i]["image_path"].stringValue
                    let price = parsed_data[i]["amount_mona"].stringValue
                    self.create_button(index:i, id: Int(id)!, title:title, price:price, image_path:image_path)
                }
            } catch { print(error) }
        }
    }
    
    internal func create_view(num_of_Q:Int) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        scrollView.frame = CGRect(x: 0, y: 90, width: viewWidth, height: viewHeight-90)
        scrollView.contentSize = CGSize(width: Int(viewWidth), height: 100*(num_of_Q+1))
        scrollView.refreshControl = refreshControl
        print("Created view for \(num_of_Q) Buttons")
        
        self.view.addSubview(scrollView)
    }
    
    internal func create_button(index:Int, id:Int, title:String, price:String, image_path:String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        let G_Button = UIButton()
        let imageView = AsyncImageView(frame: CGRect(x: 0, y: 100*index, width: 100, height: 100))
        imageView.load_image(urlString: image_path)
        imageView.image = self.image
        let title_message = title + "\n" + price + "Mona"
        
        G_Button.frame = CGRect(x:100, y:100*index, width:Int(viewWidth-100), height:100)
        G_Button.titleLabel?.numberOfLines = 0
        G_Button.setTitle(title_message, for: .normal)
        G_Button.layer.borderWidth = 1.0
        G_Button.layer.borderColor = UIColor.black.cgColor
        G_Button.setTitleColor(UIColor.black, for: .normal)
        G_Button.tag = id
        G_Button.addTarget(self, action: #selector(GoodsListViewController.goGoodsDetail(_:)), for: .touchUpInside)
//        G_Button.setImage(goods_image, for: .normal)
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(G_Button)
    }
    
    
    
    @objc func goGoodsDetail(_ sender: UIButton) {
        self.appDelegate.selected_id = sender.tag
        let goods_detail_VC = GoodsDetailViewController()
        self.navigationController?.pushViewController(goods_detail_VC, animated: true)
    }
    
    @objc func reload(sender: UIRefreshControl) {
        self.removeAllSubviews(parentView: scrollView)
        self.removeAllSubviews(parentView: self.view)
        
        self.loadView()
        self.viewDidLoad()
        
        sender.endRefreshing()
    }
    
    internal func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
}


class AsyncImageView: UIImageView {
    let CACHE_SEC : TimeInterval = 5 * 60
    
    func load_image(urlString: String) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, erroe in
            if let error = erroe {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    print(data)
                    let image = UIImage(data: data)
                    self.image = image
                }
            } else {
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }
        }
        task.resume()
    }
}

