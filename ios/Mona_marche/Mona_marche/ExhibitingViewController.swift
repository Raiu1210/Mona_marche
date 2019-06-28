//
//  ExhibitingViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit

class ExhibitingViewController: UIViewController, UITabBarDelegate {
    let track_img = UIImage(named: "./track.png")
    let title_field = UITextField()
    let address_field = UITextField()
    let memo_field = UITextField()
    let amount_field = UITextField()
    var image: UIImage?
    var imageView: UIImageView?
    var activityIndicatorView = UIActivityIndicatorView()
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
        self.tabBarItem = UITabBarItem(title: "売りたい", image: track_img, tag: 2)
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
        
        create_title_field()
        create_address_field()
        create_choose_photo_button()
    }
    
    internal func create_title_field() {
        let title_guide_label = UILabel()
        title_guide_label.frame = CGRect(x: 20, y: 250, width: 100, height: 38)
        title_guide_label.text = "商品名"
        self.view.addSubview(title_guide_label)
        
        self.title_field.text = "ここにタイトルやで！"
        self.title_field.frame = CGRect(x: 130, y: 250, width: self.view.bounds.width-140, height: 38)
        self.title_field.keyboardType = .default
        self.title_field.borderStyle = .roundedRect
        self.title_field.returnKeyType = .done
        self.title_field.clearButtonMode = .always
        self.title_field.delegate = self
        self.view.addSubview(title_field)
    }
    
    internal func create_address_field() {
        let recv_address_guide_label = UILabel()
        recv_address_guide_label.frame = CGRect(x: 20, y: 300, width: 100, height: 38)
        recv_address_guide_label.text = "受取アドレス"
        self.view.addSubview(recv_address_guide_label)
        
        address_field.text = "Your address here!"
        address_field.frame = CGRect(x: 130, y: 300, width: self.view.bounds.width-140, height: 38)
        address_field.keyboardType = .default
        address_field.borderStyle = .roundedRect
        address_field.returnKeyType = .done
        address_field.clearButtonMode = .always
        address_field.delegate = self
        self.view.addSubview(address_field)
    }
    
    internal func create_choose_photo_button() {
        let choose_photo_button = UIButton()
        choose_photo_button.setTitle("写真", for: .normal)
        choose_photo_button.backgroundColor = UIColor.orange
        choose_photo_button.sizeToFit()
        choose_photo_button.frame = CGRect(x: 10, y: 130, width: 150, height: 38)
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
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        let imgWidth:CGFloat = image.size.width
        let imgHeight:CGFloat = image.size.height
        
        let scale:CGFloat = screenWidth / (imgWidth * 2)
        let rect:CGRect = CGRect(x:0, y:0, width:imgWidth*scale, height:imgHeight*scale)
        self.imageView!.frame = rect;
        self.imageView!.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
        self.view.addSubview(self.imageView!)
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
        self.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.create_image_view(image: self.image!)
    }
}
