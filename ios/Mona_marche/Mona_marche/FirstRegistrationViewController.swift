//
//  FirstRegistrationViewController.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/28.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit

class FirstRegistrationViewController : UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let registration_address_field = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        check_existing_monawallet()
        create_open_button()
        create_address_input_field()
        create_registration_button()
    }
    
    internal func check_existing_monawallet() {
        if UIApplication.shared.canOpenURL(URL(string: "monawallet://")!) {
            print("Monawallet インストール済み")
        } else {
            print("Monawallet インストールされていない")
            let alert: UIAlertController = UIAlertController(title: "Monawalletがインストールされていません", message: "このアプリを使うにはMonawalletがないと、ちょっと不便かもしれません。App storeからMonawalletをダウンロードしますか？", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                let url = URL(string: "https://apps.apple.com/jp/app/monawallet/id1343235820")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if success {
                            print("Launching \(url) was successful")
                        }
                    }
                }
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Canceled")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    internal func create_open_button() {
        let open_button = UIButton()
        open_button.titleLabel?.numberOfLines = 0
        open_button.setTitle("Monawallet\nを開く", for: .normal)
        open_button.backgroundColor = UIColor.orange
        open_button.sizeToFit()
        open_button.layer.cornerRadius = 10.0
        open_button.frame = CGRect(x: 230, y: 60, width: 110, height: 80)
        open_button.addTarget(self, action: #selector(open_monawallet(_:)), for: .touchUpInside)
        
        self.view.addSubview(open_button)
    }
    
    @objc func open_monawallet(_ sender:UIButton) {
        let url = URL(string: "monawallet://")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    internal func create_address_input_field() {
        let registration_address_guide_label = UILabel()
        registration_address_guide_label.frame = CGRect(x: self.view.bounds.width/2-170, y: 200, width: 340, height: 38)
        registration_address_guide_label.text = "モナコインアドレスを登録してください！"
        registration_address_guide_label.textAlignment = NSTextAlignment.center
        self.view.addSubview(registration_address_guide_label)
        
        registration_address_field.text = "Your address here!"
        registration_address_field.frame = CGRect(x: 30, y: 250, width: self.view.bounds.width-60, height: 38)
        registration_address_field.keyboardType = .default
        registration_address_field.borderStyle = .roundedRect
        registration_address_field.returnKeyType = .done
        registration_address_field.clearButtonMode = .always
        registration_address_field.delegate = self
        self.view.addSubview(registration_address_field)
    }
    
    internal func create_registration_button() {
        let registration_button = UIButton()
        registration_button.frame = CGRect(x:self.view.bounds.width/2-100, y:320, width:200, height:40)
        registration_button.titleLabel?.numberOfLines = 0
        registration_button.setTitle("登録！", for: .normal)
        registration_button.layer.borderWidth = 1.0
        registration_button.backgroundColor = UIColor.orange
        registration_button.layer.borderColor = UIColor.black.cgColor
        registration_button.setTitleColor(UIColor.black, for: .normal)
        registration_button.addTarget(self, action: #selector(registration(_:)), for: .touchUpInside)
        self.view.addSubview(registration_button)
    }
    
    @objc func registration(_ sender: UIButton) {
        var status = true
        let input_address = registration_address_field.text
        if input_address?.count != 34 { status = false }
        let first_character = registration_address_field.text!.prefix(1)
        if first_character != "P" && first_character != "M" { status = false }
        
        if status {
            do {
                print(appDelegate.registrated_address_file_path)
                try input_address!.write(toFile: appDelegate.registrated_address_file_path, atomically: true, encoding: String.Encoding.utf8)
                print("wrote jsonString to file")
                let add_url: String = "http://zihankimap.work/mona/register_address.php?mona_address=\(String(describing: input_address!))"
                print(add_url)
                let url = URL(string: add_url)!
                let task = URLSession.shared.dataTask(with: url) {data, response, error in
                    print("done session")
                }
                task.resume()
                self.appDelegate.registrated_address = input_address!
                let registerd_address_alert: UIAlertController = UIAlertController(title: "準備OK！", message: "オッケー！モナコインで買い物したり、売ったりして楽しもう！",  preferredStyle: .alert)
                let done_Action = UIAlertAction(title: "あいあいさ〜", style: .default) { action in
                    self.appDelegate.finish_register()
                }
                registerd_address_alert.addAction(done_Action)
                present(registerd_address_alert, animated: true, completion: nil)
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
        } else {
            let wrong_address_alert: UIAlertController = UIAlertController(title: "ありゃ", message: "アドレスがおかしいっぽいよ。\nしっかり確認してコピペしよう！",  preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "あいあいさ〜", style: .default) { action in }
            wrong_address_alert.addAction(OkAction)
            present(wrong_address_alert, animated: true, completion: nil)
        }
    }
    
    func go_shopping() {
        let shopping_vc = GoodsListViewController()
        self.present(shopping_vc, animated: true, completion: nil)
        print("why I'm here")
    }
}

extension FirstRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

