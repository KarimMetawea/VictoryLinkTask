//
//  LoginVC.swift
//  VictoryLinkTask
//
//  Created by karim metawea on 2/10/20.
//  Copyright © 2020 karim metawea. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        if self.emailTextField.text != "" && self.passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (result, error) in
                if let error = error {
                    print(error.localizedDescription )
                    return
                }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! UINavigationController
                DispatchQueue.main.async {
                    self.present(vc,animated: true)
                }
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
