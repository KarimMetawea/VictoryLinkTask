//
//  SignupVC.swift
//  VictoryLinkTask
//
//  Created by karim metawea on 2/10/20.
//  Copyright © 2020 karim metawea. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class SignupVC: UIViewController {

    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIELD: UITextField!
    
    var ref:DatabaseReference?

    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        profileImage.addTapGestureRecognizer {
            self.checkPhotoLibraryAuthorization()
        }


        // Do any additional setup after loading the view.
    }
    
    fileprivate func navigateToHome() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! UINavigationController
        DispatchQueue.main.async{
            self.present(vc,animated: true)
        }
    }
    
    @IBAction func joinPressed(_ sender: Any) {
        
        
        if self.nameTextField.text != "" && self.emailTextField.text != "" && self.passwordTextFIELD.text != ""
        {
            Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextFIELD.text ?? "") { (result, error) in
                if error != nil {
                    print(error)
                    return}
                if let image = self.image {
                    self.uploadMedia { (url) in
                                       self.ref?.child("user").childByAutoId().setValue(["imgUrl":url ?? ""])
                        self.navigateToHome()
                                              }
                }else {
                    self.navigateToHome()
                }
               

                
                
            }
            
           
            

           



        }
    }
    
    func checkPhotoLibraryAuthorization(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
                
            case .notDetermined:
                if status == PHAuthorizationStatus.authorized{
                    self.presentPickerController()
                }
            case .restricted:
                let ac = UIAlertController(title: "Access Restricted", message: "you restricted this app from using photo library you can enable it in phone settings", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(ac,animated: true)
                
            case .denied:
                let ac = UIAlertController(title: "access denied", message: "you denied this app from using photo library you can enable it in phone settings", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                ac.addAction(UIAlertAction(title: "Go Settings", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        //                            opening the user settings
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    }
                }))
                self.present(ac,animated: true)
                
            case .authorized:
                DispatchQueue.main.async {
                    self.presentPickerController()
                }
                
            }
        }
    }
    
    fileprivate func presentPickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker,animated: true)
    }
    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("myImage.png")
        if let image = image{
            if let uploadData = image.pngData() {
                      storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                          if error != nil {
                              print("error")
                              completion(nil)
                          } else {
                            storageRef.downloadURL { (url, error) in
                                if let imgurl = url?.absoluteString{
                                    
                                    completion(imgurl)
                                }
                            }
//                            completion()
                              // your uploaded photo url.
                          }
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



extension SignupVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //    delegate methods for choosing an image from library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.profileImage.image = image
            self.image = image
        }
        //        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        //            self.image = image
        //        }
        dismiss(animated: true, completion: nil)
    }
}
