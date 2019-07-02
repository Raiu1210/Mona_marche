//
//  ExhibitingViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import CropViewController

class ExhibitingViewController: UIViewController, UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let track_img = UIImage(named: "./track.png")
    let title_field   = UITextField()
    let address_field = UITextField()
    let memo_field    = UITextView()
    let amount_field  = UITextField()
    var image: UIImage?
    var imageView: UIImageView?
    var activityIndicatorView = UIActivityIndicatorView()
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
        self.tabBarItem = UITabBarItem(title: "売りたい", image: track_img, tag: 2)
        self.title_field.text = ""
        self.amount_field.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // タッチしたらキーボードが閉じるで〜
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        create_choose_photo_button()
        create_title_field()
        create_address_field()
        create_memo_field()
        create_amount_field()
        create_send_button()
    }
    
    internal func create_choose_photo_button() {
        let choose_photo_button = UIButton()
        choose_photo_button.setTitle("写真", for: .normal)
        choose_photo_button.backgroundColor = UIColor.orange
        choose_photo_button.sizeToFit()
        choose_photo_button.frame = CGRect(x: 10, y: 70, width: 70, height: 38)
        choose_photo_button.addTarget(self, action: #selector(choose_photo_from_camera_roll(_:)), for: .touchUpInside)
        
        self.view.addSubview(choose_photo_button)
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
        self.imageView!.frame = CGRect(x:100, y:50, width:100, height:100)
        self.view.addSubview(self.imageView!)
    }
    
    
    internal func create_title_field() {
        let title_guide_label = UILabel()
        title_guide_label.frame = CGRect(x: 20, y: 170, width: 100, height: 38)
        title_guide_label.text = "商品名"
        self.view.addSubview(title_guide_label)
        
        self.title_field.frame = CGRect(x: 130, y: 170, width: self.view.bounds.width-140, height: 38)
        self.title_field.keyboardType = .default
        self.title_field.borderStyle = .roundedRect
        self.title_field.returnKeyType = .done
        self.title_field.clearButtonMode = .always
        self.title_field.delegate = self
        self.view.addSubview(title_field)
    }
    
    internal func create_address_field() {
        let recv_address_guide_label = UILabel()
        recv_address_guide_label.frame = CGRect(x: 20, y: 220, width: 100, height: 38)
        recv_address_guide_label.text = "受取アドレス"
        self.view.addSubview(recv_address_guide_label)
        
        address_field.frame = CGRect(x: 130, y: 220, width: self.view.bounds.width-140, height: 38)
        address_field.keyboardType = .default
        address_field.borderStyle = .roundedRect
        address_field.returnKeyType = .done
        address_field.clearButtonMode = .always
        address_field.delegate = self
        self.view.addSubview(address_field)
    }
    
    internal func create_memo_field() {
        let memo_guide_label = UILabel()
        memo_guide_label.frame = CGRect(x: 20, y: 270, width: 100, height: 38)
        memo_guide_label.text = "商品説明"
        self.view.addSubview(memo_guide_label)
        
        self.memo_field.frame = CGRect(x: 130, y: 270, width: self.view.bounds.width-140, height: 138)
        self.memo_field.layer.borderWidth = 0.3
        self.memo_field.layer.cornerRadius = 6.0
        self.memo_field.layer.borderColor = UIColor.lightGray.cgColor
        self.memo_field.layer.masksToBounds = true
        
        
        self.view.addSubview(self.memo_field)
    }
    
    
    internal func create_amount_field() {
        let amount_guide_label = UILabel()
        amount_guide_label.frame = CGRect(x: 20, y: 420, width: 70, height: 38)
        amount_guide_label.text = "金額"
        self.view.addSubview(amount_guide_label)
        
        let mona_label = UILabel()
        mona_label.frame = CGRect(x: 290, y: 420, width: 70, height: 38)
        mona_label.text = "Mona"
        self.view.addSubview(mona_label)
        
        amount_field.frame = CGRect(x: 130, y: 420, width: 150, height: 38)
        amount_field.keyboardType = .decimalPad
        amount_field.borderStyle = .roundedRect
        amount_field.returnKeyType = .done
        amount_field.clearButtonMode = .always
        amount_field.delegate = self
        self.view.addSubview(amount_field)
    }
    
    internal func create_send_button() {
        let send_button = UIButton()
        send_button.setTitle("出品する", for: .normal)
        send_button.backgroundColor = UIColor.orange
        send_button.sizeToFit()
        send_button.frame = CGRect(x: self.view.bounds.width/2-50, y: 500, width: 100, height: 38)
        send_button.addTarget(self, action: #selector(send_server(_:)), for: .touchUpInside)
        
        self.view.addSubview(send_button)
    }
    
    @objc func send_server(_: UIButton) {
        // check inputs
        var status = true
        let first_character = address_field.text!.prefix(1)
        
        if self.image == nil {status = false}
        if self.title_field.text == "" {status = false}
        if self.address_field.text!.count != 34 { status = false }
        if first_character != "P" && first_character != "M" {status = false}
        if self.memo_field.text == "" {status = false}
        if self.amount_field.text == "" {status = false}
        
        
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
            "memo"    : self.memo_field.text!,
            "amount"  : self.amount_field.text!
        ]
        
//        let url = URL(string: "http://zihankimap.work/mona/uplaod_new_goods.php")
        let url = URL(string: "http://zihankimap.work/mona/upload")
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
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.imageView?.image = nil
                    self.title_field.text = ""
                    self.address_field.text = ""
                    self.memo_field.text = ""
                    self.amount_field.text = ""
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
    
    internal func create_activity_indicator() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        activityIndicatorView.frame = CGRect(x: 300, y: 300, width: 60, height: 60)
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .lightGray
        self.view.addSubview(activityIndicatorView)
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
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        // キャンセル時
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
