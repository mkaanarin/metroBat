//
//  ViewController.swift
//  metroBat
//
//  Created by Mustafa Kaan Arın on 16.02.2024.
//

import UIKit
import Firebase

class loginScreen: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            
            Auth.auth().signIn(withEmail: emailText.text!, password : passwordText.text!){
                (authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Bir hatayla karşılaşıldı")
                }
                else{
                    self.performSegue(withIdentifier: "toHamburger", sender: nil)
                }
            }
            
        }
        else{
            makeAlert(titleInput: "ERROR!", messageInput: "Username/Password?")
        }
        
    }
    
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        }
        
}

