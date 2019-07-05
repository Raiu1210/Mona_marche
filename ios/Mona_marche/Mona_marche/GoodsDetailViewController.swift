//
//  GoodsDetailViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/07/04.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsDetailViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let scrollView = UIScrollView()
    let memo_field = UITextView()
    var goods_data:[String:String] = [:]
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    var image: UIImage?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        self.view.backgroundColor = UIColor.white
        self.prepare_goods_info()
        self.create_goods_image_view()
        self.create_memo_field_view()
        self.create_payment_info()
        self.create_buy_button()
    }
    
    private func prepare_goods_info(){
        let selected_id = appDelegate.selected_id?.description
        let jsonString = appDelegate.goods_json_string
        let json_Data: Data =  jsonString.data(using: String.Encoding.utf8)!
        let parsed_data = try! JSON(data: json_Data)
        
        while parsed_data[index]["id"].stringValue != selected_id {
            index += 1
        }
        
        self.goods_data.updateValue(parsed_data[index]["id"].stringValue, forKey: "id")
        self.goods_data.updateValue(parsed_data[index]["timestamp"].stringValue, forKey: "timestamp")
        self.goods_data.updateValue(parsed_data[index]["registered_address"].stringValue, forKey: "registered_address")
        self.goods_data.updateValue(parsed_data[index]["title"].stringValue, forKey: "title")
        self.goods_data.updateValue(parsed_data[index]["pay_address"].stringValue, forKey: "pay_address")
        self.goods_data.updateValue(parsed_data[index]["memo"].stringValue, forKey: "memo")
        self.goods_data.updateValue(parsed_data[index]["amount_mona"].stringValue, forKey: "amount_mona")
        self.goods_data.updateValue(parsed_data[index]["image_path"].stringValue, forKey: "image_path")
        
        self.title = goods_data["title"]
        
        self.create_view(height: 1500)
    }
    
    internal func create_view(height:Int) {
        scrollView.frame = CGRect(x: 0, y: 90, width: viewWidth, height: viewHeight-90)
        scrollView.contentSize = CGSize(width: Int(viewWidth), height: height)
        
        self.view.addSubview(scrollView)
    }
    
    internal func create_goods_image_view() {
        let imageView = AsyncImageView(frame: CGRect(x: self.viewWidth/2-100, y: 30, width: 200, height: 200))
        imageView.load_image(urlString: goods_data["image_path"]!)
        imageView.image = self.image
        
        self.scrollView.addSubview(imageView)
    }
    
    internal func create_memo_field_view() {
        let memo_guide_label = UILabel()
        memo_guide_label.frame = CGRect(x: 20, y: 260, width: 100, height: 38)
        memo_guide_label.text = "商品説明"
        self.scrollView.addSubview(memo_guide_label)
        
        self.memo_field.frame = CGRect(x: 20, y: 300, width: self.view.bounds.width-40, height: 700)
        self.memo_field.layer.borderWidth = 0.3
        self.memo_field.layer.cornerRadius = 6.0
        self.memo_field.layer.borderColor = UIColor.lightGray.cgColor
        self.memo_field.layer.masksToBounds = true
        self.memo_field.isEditable = false
        self.memo_field.text = goods_data["memo"]
        self.memo_field.font = UIFont.systemFont(ofSize: 18)
        self.memo_field.dataDetectorTypes = UIDataDetectorTypes.all
        
        self.scrollView.addSubview(self.memo_field)
    }
    
    internal func create_payment_info() {
        let send_address_label = UILabel()
        send_address_label.frame = CGRect(x: 20, y: 1020, width: 150, height: 38)
        send_address_label.text = "送信先アドレス:"
        self.scrollView.addSubview(send_address_label)
        
        let address_field = UITextView()
        address_field.frame = CGRect(x: 20, y: 1050, width: self.viewWidth-40, height: 38)
        address_field.text = goods_data["pay_address"]
        address_field.font = UIFont.systemFont(ofSize: 14)
        address_field.isEditable = false
        self.scrollView.addSubview(address_field)
        
        
        let amount_label = UILabel()
        amount_label.frame = CGRect(x: 20, y: 1090, width: 100, height: 38)
        amount_label.text = "送金額:"
        self.scrollView.addSubview(amount_label)
        
        let amount_field = UITextView()
        amount_field.frame = CGRect(x: 90, y: 1090, width: self.viewWidth-110, height: 38)
        amount_field.text = goods_data["amount_mona"]! + " Mona"
        amount_field.font = UIFont.systemFont(ofSize: 18)
        amount_field.isEditable = false
        self.scrollView.addSubview(amount_field)
    }
    
    internal func create_buy_button() {
        let buy_button = UIButton()
        buy_button.frame = CGRect(x:self.viewWidth/2-50, y:1150, width:100, height:40)
        buy_button.setTitle("購入", for: .normal)
        buy_button.layer.borderWidth = 1.0
        buy_button.layer.borderColor = UIColor.black.cgColor
        buy_button.setTitleColor(UIColor.black, for: .normal)
//        buy_button.tag = id
        buy_button.addTarget(self, action: #selector(buy(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(buy_button)
    }
    
    @objc func buy(_ sender: UIButton) {
        let confirm_buy_alert: UIAlertController = UIAlertController(title: "購入確認", message: "この商品を購入しますか？",  preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "購入する", style: .default) { action in }
        confirm_buy_alert.addAction(OkAction)
        present(confirm_buy_alert, animated: true, completion: nil)
    }
}


