//
//  ExhibitingViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import CropViewController
import SwiftyJSON

class ExhibitingViewController: UIViewController, UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let track_img = UIImage(named: "./track.png")
    let photo_img = UIImage(named: "./photo_img.png")
    let list: [String] = ["JPY", "MONA"]
    let title_field   = UITextField()
    let address_field = UITextField()
    let contact_field = UITextField()
    let memo_field    = UITextView()
    let scrollView = UIScrollView()
    let price_field  = UITextField()
    var selected_currency = ""
    var image: UIImage?
    var imageView: UIImageView?
    var picker_view: UIPickerView = UIPickerView()
    var activityIndicatorView = UIActivityIndicatorView()
    var navigation_bar_height:CGFloat = 0.0
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
        self.tabBarItem = UITabBarItem(title: "売りたい", image: track_img, tag: 2)
        self.title_field.text = ""
        self.price_field.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        navigation_bar_height = self.navigationController?.navigationBar.frame.size.height ?? 80
        
        create_view(height:800)
        create_choose_photo_button()
        create_activity_indicator()
        create_title_field()
        create_address_field()
        create_contact_field()
        create_memo_field()
        create_amount_field()
        create_choose_currency_view()
        create_send_button()
        create_open_button()
    }
    
    internal func create_view(height:Int) {
        scrollView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        scrollView.contentSize = CGSize(width: Int(viewWidth), height: height)
        scrollView.keyboardDismissMode = .onDrag
        
        self.view.addSubview(scrollView)
    }
    
    internal func create_choose_photo_button() {
        let choose_photo_button = UIButton()
        choose_photo_button.sizeToFit()
        choose_photo_button.layer.cornerRadius = 10.0
        choose_photo_button.frame = CGRect(x: 30, y: 65, width: 40, height: 50)
        choose_photo_button.setImage(self.photo_img, for: .normal)
        choose_photo_button.addTarget(self, action: #selector(choose_photo_from_camera_roll(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(choose_photo_button)
    }
    
    @objc internal func choose_photo_from_camera_roll(_ sender:UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    internal func create_image_view(image:UIImage) {
        self.imageView?.image = nil
        self.imageView = UIImageView(image: image)
        self.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        self.imageView!.frame = CGRect(x:100, y:30, width:120, height:120)
        self.scrollView.addSubview(self.imageView!)
    }
    
    
    internal func create_title_field() {
        let title_guide_label = UILabel()
        title_guide_label.frame = CGRect(x: 20, y: 170, width: 100, height: 38)
        title_guide_label.text = "商品名"
        self.scrollView.addSubview(title_guide_label)
        
        self.title_field.frame = CGRect(x: 130, y: 170, width: self.view.bounds.width-140, height: 38)
        self.title_field.keyboardType = .default
        self.title_field.borderStyle = .roundedRect
        self.title_field.returnKeyType = .done
        self.title_field.clearButtonMode = .always
        self.title_field.delegate = self
        self.scrollView.addSubview(title_field)
    }
    
    internal func create_address_field() {
        let recv_address_guide_label = UILabel()
        recv_address_guide_label.frame = CGRect(x: 20, y: 220, width: 100, height: 38)
        recv_address_guide_label.text = "受取アドレス"
        self.scrollView.addSubview(recv_address_guide_label)
        
        address_field.frame = CGRect(x: 130, y: 220, width: self.view.bounds.width-140, height: 38)
        address_field.keyboardType = .default
        address_field.borderStyle = .roundedRect
        address_field.returnKeyType = .done
        address_field.clearButtonMode = .always
        address_field.delegate = self
        self.scrollView.addSubview(address_field)
    }
    
    internal func create_contact_field() {
        let contact_guide_label = UILabel()
        contact_guide_label.frame = CGRect(x: 20, y: 270, width: 100, height: 38)
        contact_guide_label.text = "連絡先"
        self.scrollView.addSubview(contact_guide_label)
        
        contact_field.frame = CGRect(x: 130, y: 270, width: self.view.bounds.width-140, height: 38)
        contact_field.keyboardType = .default
        contact_field.borderStyle = .roundedRect
        contact_field.returnKeyType = .done
        contact_field.clearButtonMode = .always
        contact_field.delegate = self
        self.scrollView.addSubview(contact_field)
    }
    
    internal func create_memo_field() {
        let memo_guide_label = UILabel()
        memo_guide_label.frame = CGRect(x: 20, y: 320, width: 100, height: 38)
        memo_guide_label.text = "商品説明"
        self.scrollView.addSubview(memo_guide_label)
        
        self.memo_field.frame = CGRect(x: 130, y: 320, width: self.view.bounds.width-140, height: 138)
        self.memo_field.layer.borderWidth = 0.3
        self.memo_field.layer.cornerRadius = 6.0
        self.memo_field.layer.borderColor = UIColor.lightGray.cgColor
        self.memo_field.layer.masksToBounds = true
        
        
        self.scrollView.addSubview(self.memo_field)
    }
    
    
    internal func create_amount_field() {
        let amount_guide_label = UILabel()
        amount_guide_label.frame = CGRect(x: 20, y: 500, width: 70, height: 38)
        amount_guide_label.text = "金額"
        self.scrollView.addSubview(amount_guide_label)
        
        
        price_field.frame = CGRect(x: 130, y: 500, width: 130, height: 38)
        price_field.keyboardType = .decimalPad
        price_field.borderStyle = .roundedRect
        price_field.returnKeyType = .done
        price_field.clearButtonMode = .always
        price_field.delegate = self
        self.scrollView.addSubview(price_field)
    }
    
    internal func create_choose_currency_view() {
        picker_view.delegate = self
        picker_view.dataSource = self
        picker_view.showsSelectionIndicator = true
        
        picker_view.frame = CGRect(x: 280, y: 470, width: 70, height: 100)
        picker_view.selectRow(1, inComponent: 0, animated: true)
    
        self.scrollView.addSubview(self.picker_view)
    }
    
    
    internal func create_send_button() {
        let send_button = UIButton()
        send_button.setTitle("出品する", for: .normal)
        send_button.sizeToFit()
        send_button.layer.cornerRadius = 10.0
        send_button.backgroundColor = UIColor(red: 250/255, green: 40/255, blue: 10/255, alpha: 0.9)
        send_button.frame = CGRect(x: self.view.bounds.width/2-50, y: 570, width: 100, height: 38)
        send_button.addTarget(self, action: #selector(send_server(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(send_button)
    }
    
    @objc func send_server(_: UIButton) {
        // check inputs
        var status = true
        let first_character = address_field.text!.prefix(1)
        
        if self.image == nil {status = false}
        if self.title_field.text == "" {status = false}
        if self.address_field.text!.count != 34 { status = false }
        if first_character != "P" && first_character != "M" {status = false}
        if self.contact_field.text == "" {status = false}
        if self.memo_field.text == "" {status = false}
        if self.price_field.text == "" {status = false}
        
        
        if status {
            self.send_info_to_server()
        } else {
            let wrong_address_alert: UIAlertController = UIAlertController(title: "ありゃ", message: "ちゃんと全部正しく入力したか確認しよう",  preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "ういっすー", style: .default) { action in }
            wrong_address_alert.addAction(OkAction)
            present(wrong_address_alert, animated: true, completion: nil)
            return
        }
    }
    
    internal func send_info_to_server() {
        let param = [
            "registered_address" : self.appDelegate.registrated_address,
            "title"  : self.title_field.text!,
            "pay_address" : self.address_field.text!,
            "contact": self.contact_field.text!,
            "memo"    : self.memo_field.text!,
            "price"  : self.price_field.text!,
            "currency" : self.selected_currency
        ]
        
        print("contact is \(self.contact_field.text!)")
        
        let url = URL(string: "http://zihankimap.work/mona/uplaod_new_goods.php")
        let boundary = self.generateBoundaryString()
        let image_data = (self.image?.jpegData(compressionQuality: 0.5))!
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: image_data as NSData, boundary: boundary) as Data
        self.activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .default).async {
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                print("******* response = \(response)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                do {
                    let json_Data: Data =  responseString!.data(using: String.Encoding.utf8.rawValue)!
                    let parsed_data = try JSON(data: json_Data)
                    if parsed_data["Status"] == "OK" {
                        let sent_successfully_alert: UIAlertController = UIAlertController(title: "Good job!", message: "ちゃんとサーバに登録されたっぽいでー",  preferredStyle: .alert)
                        let OkAction = UIAlertAction(title: "よかった〜", style: .default) { action in }
                        sent_successfully_alert.addAction(OkAction)
                        self.present(sent_successfully_alert, animated: true, completion: nil)
                    } else {
                        let sent_missed_alert: UIAlertController = UIAlertController(title: "OMG", message: "なんかミスってるっぽいw",  preferredStyle: .alert)
                        let OkAction = UIAlertAction(title: "まじか〜", style: .default) { action in }
                        sent_missed_alert.addAction(OkAction)
                        self.present(sent_missed_alert, animated: true, completion: nil)
                    }
                } catch { print(error) }
                
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.imageView?.image = nil
                    self.title_field.text = ""
                    self.address_field.text = ""
                    self.contact_field.text = ""
                    self.memo_field.text = ""
                    self.price_field.text = ""
                }
            }
            task.resume()
        }
    }
    
    internal func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    internal func createBodyWithParameters(parameters:[String:String]?, filePathKey:String?, imageDataKey:NSData, boundary:String) -> NSData {
        
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpeg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    internal func create_open_button() {
        let open_button = UIButton()
        open_button.titleLabel?.numberOfLines = 0
        open_button.setTitle("Monawallet\nを開く", for: .normal)
        open_button.sizeToFit()
        open_button.layer.cornerRadius = 10.0
        open_button.backgroundColor = UIColor.orange
        open_button.frame = CGRect(x: 230, y: 60, width: 110, height: 80)
        open_button.addTarget(self, action: #selector(open_monawallet(_:)), for: .touchUpInside)
        
        self.scrollView.addSubview(open_button)
    }
    
    @objc func open_monawallet(_ sender:UIButton) {
        let url = URL(string: "monawallet://")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    internal func create_activity_indicator() {
        activityIndicatorView.frame = CGRect(x: 80, y: 500, width: 60, height: 60)
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .lightGray
        self.scrollView.addSubview(activityIndicatorView)
    }
}

extension ExhibitingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension ExhibitingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // キャンセルボタンを押された時に呼ばれる
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 写真が選択された時に呼ばれる
        print("Picked image")
        self.dismiss(animated: true)
        
        let cropViewController = CropViewController(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
}

extension ExhibitingViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //加工した画像が取得できる
        self.image = image
        self.create_image_view(image: self.image!)
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController:CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    
}


extension ExhibitingViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        
        pickerLabel.text = list[row]
        self.selected_currency = list[row]
        
        return pickerLabel
    }
    
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected_currency = list[row]
//        print("selected currency is \(self.selected_currency)")
     }
}
