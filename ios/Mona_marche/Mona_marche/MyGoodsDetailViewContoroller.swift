//
//  MyGoodsDetailViewContoroller.swift
//  Mona_marche
//
//  Created by raiu on 2019/07/07.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//


import UIKit
import SwiftyJSON

class MyGoodsDetailViewController: UIViewController {
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
        self.create_delete_goods_button()
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
        self.goods_data.updateValue(parsed_data[index]["contact"].stringValue, forKey: "contact")
        self.goods_data.updateValue(parsed_data[index]["memo"].stringValue, forKey: "memo")
        self.goods_data.updateValue(parsed_data[index]["price"].stringValue, forKey: "price")
        self.goods_data.updateValue(parsed_data[index]["currency"].stringValue, forKey: "currency")
        self.goods_data.updateValue(parsed_data[index]["image_path"].stringValue, forKey: "image_path")
        
        self.title = goods_data["title"]
        
        self.create_view(height: 1500)
    }
    
    
    internal func create_view(height:Int) {
        scrollView.frame = CGRect(x: 0, y: 80, width: viewWidth, height: viewHeight-80)
        scrollView.contentSize = CGSize(width: Int(viewWidth), height: height)
        
        self.view.addSubview(scrollView)
    }
    
    
    internal func create_goods_image_view() {
        let imageView = AsyncImageView(frame: CGRect(x: self.viewWidth*0.1, y: 10, width: self.viewWidth*0.8, height: 300))
        imageView.load_image(urlString: goods_data["image_path"]!)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self.image
        
        self.scrollView.addSubview(imageView)
    }
    
    
    internal func create_memo_field_view() {
        let memo_guide_label = UILabel()
        memo_guide_label.frame = CGRect(x: 20, y: 310, width: 100, height: 38)
        memo_guide_label.text = "商品説明"
        self.scrollView.addSubview(memo_guide_label)
        
        self.memo_field.frame = CGRect(x: 20, y: 350, width: self.view.bounds.width-40, height: 700)
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
        let contact_label = UILabel()
        contact_label.frame = CGRect(x: 20, y: 1070, width: 70, height: 38)
        contact_label.text = "連絡先："
        self.scrollView.addSubview(contact_label)
        
        let contact_field = UITextView()
        contact_field.frame = CGRect(x: 80, y: 1070, width: self.viewWidth-120, height: 38)
        contact_field.text = goods_data["contact"]
        contact_field.font = UIFont.systemFont(ofSize: 14)
        contact_field.isEditable = false
        self.scrollView.addSubview(contact_field)
        
        let send_address_label = UILabel()
        send_address_label.frame = CGRect(x: 20, y: 1120, width: 150, height: 38)
        send_address_label.text = "送信先アドレス:"
        self.scrollView.addSubview(send_address_label)
        
        let address_field = UITextView()
        address_field.frame = CGRect(x: 20, y: 1150, width: self.viewWidth-40, height: 38)
        address_field.text = goods_data["pay_address"]
        address_field.font = UIFont.systemFont(ofSize: 14)
        address_field.isEditable = false
        self.scrollView.addSubview(address_field)
        
        
        let amount_label = UILabel()
        amount_label.frame = CGRect(x: 20, y: 1190, width: 100, height: 38)
        amount_label.text = "送金額:"
        self.scrollView.addSubview(amount_label)
        
        var display_price = ""
        if goods_data["currency"] == "MONA" {
            let JPY_price = Double(goods_data["price"]!)! * self.appDelegate.mona_jpy_price
            display_price = "\(goods_data["price"]!) MONA\n(\(JPY_price) JPY)"
        } else if goods_data["currency"] == "JPY" {
            let MONA_price = Double(goods_data["price"]!)! / self.appDelegate.mona_jpy_price
            display_price = "\(goods_data["price"]!) JPY\n(\(MONA_price) MONA)"
        }
        
        let amount_field = UITextView()
        amount_field.frame = CGRect(x: 90, y: 1190, width: self.viewWidth-110, height: 80)
        amount_field.text = display_price
        amount_field.font = UIFont.systemFont(ofSize: 18)
        amount_field.isEditable = false
        self.scrollView.addSubview(amount_field)
    }
    
    
    internal func create_delete_goods_button() {
        let delete_goods_button = UIButton()
        delete_goods_button.frame = CGRect(x:self.viewWidth/2-80, y:1300, width:160, height:40)
        delete_goods_button.setTitle("出品取り消し", for: .normal)
        delete_goods_button.layer.cornerRadius = 10.0
        delete_goods_button.layer.borderWidth = 1.0
        delete_goods_button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        delete_goods_button.setTitleColor(UIColor.white, for: .normal)
        delete_goods_button.layer.borderColor = UIColor.black.cgColor
        delete_goods_button.backgroundColor = UIColor(red: 250/255, green: 40/255, blue: 10/255, alpha: 0.9)
        
        delete_goods_button.addTarget(self, action: #selector(delete_goods(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(delete_goods_button)
    }
    
    
    @objc func delete_goods(_ sender: UIButton) {
        let confirm_buy_alert: UIAlertController = UIAlertController(title: "確認", message: "この商品を削除しますか？\n\n",  preferredStyle: .actionSheet)
        let buy_Action = UIAlertAction(title: "削除する", style: .default) { action in
            self.delete_from_db()
        }
        confirm_buy_alert.addAction(buy_Action)
        
        let no_Action = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            return
        }
        confirm_buy_alert.addAction(no_Action)
        present(confirm_buy_alert, animated: true, completion: nil)
    }
    
    
    internal func delete_from_db() {
        let confirm_delete_alert: UIAlertController = UIAlertController(title: "削除確認", message: "この商品を削除しますか？",  preferredStyle: .actionSheet)
        let delete_Action = UIAlertAction(title: "削除する", style: .default) { action in
            let delete_url_string = "http:/zihankimap.work/mona/delete.php?registered_address=\(self.appDelegate.registrated_address)&id=\(self.appDelegate.selected_id!)"
            let url = URL(string: delete_url_string)!
            print("URL : \(url)")
            let request = URLRequest(url: url)
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in if error == nil, let data = data, let response = response as? HTTPURLResponse {
                _ = String(data: data, encoding: String.Encoding.utf8) ?? ""
                }
                }.resume()
            self.navigationController?.popViewController(animated: true)
        }
        confirm_delete_alert.addAction(delete_Action)
        let no_Action = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            return
        }
        confirm_delete_alert.addAction(no_Action)
        present(confirm_delete_alert, animated: true, completion: nil)
    }

}



