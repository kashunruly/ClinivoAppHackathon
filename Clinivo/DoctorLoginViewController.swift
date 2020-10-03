//
//  DoctorLoginViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DoctorLoginViewController: UIViewController {

    @IBOutlet weak var goBack_btn: UIButton!
    
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var doctor_password: UITextField!
    @IBOutlet weak var doctor_username: UITextField!
    
    var transparentView = UIView()
    var tableView = UITableView()
    var height: CGFloat = 450
    var mainView = true
    var type = ""
    var keyboardHeight: CGFloat = 0
    var keyboardIsShowing = false
    
    
    var doctorSignupCell: DoctorSignuptableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if let _ = doctor_username{
        
            
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 510
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 237/255, alpha: 1)
            
            doctor_username.layer.cornerRadius = 20
            doctor_password.layer.cornerRadius = 20
            
            login_btn.layer.cornerRadius = 20
            login_btn.applyShadow()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
       
        
        Utils.reg(cell: "DoctorSignupCell", nibName: "DoctorSignupCell", tableView: tableView)
    }
    
    
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        if !mainView{
            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                 keyboardHeight = keyboardSize.height
                    let screenSize = UIScreen.main.bounds.size
                     if keyboardHeight > 300{
                         
                         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                             self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height - self.keyboardHeight / 2, width: screenSize.width, height: self.height)
                         }, completion: nil)
                     }else{
                         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                             self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height - self.keyboardHeight/2 + 5, width: screenSize.width, height: self.height)
                         }, completion: nil)
                     }
                    self.view.layoutIfNeeded()
                self.keyboardIsShowing = true
                     print(keyboardHeight)
                
             
            }

        }
       }
       
      

       @objc func keyboardWillHide(sender: NSNotification) {
        if !mainView{
            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.height
               let screenSize = UIScreen.main.bounds.size
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                   self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
               }, completion: nil)
               
               self.view.layoutIfNeeded()
                print(keyboardHeight)
               self.keyboardIsShowing = false
               
            }
        }
       }
    
    @IBAction func signup_btn_tapped(_ sender: Any) {
        
        patient_tapped()
    }
    
    @IBAction func login_btn_tapped(_ sender: Any) {
        
        
        let email = doctor_username.text ?? ""
        
        let password = doctor_password.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                  
                  guard let user = result?.user, error == nil else {
                      if let error = error {
                          let authError = error as NSError
                          if (authError.code == AuthErrorCode.wrongPassword.rawValue || authError.code == AuthErrorCode.invalidRecipientEmail.rawValue ) {
                                            
                              let alert = UIAlertController(title: "Login Error", message: "Check Email/ Password", preferredStyle: .alert)
                              let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                              alert.addAction(action)


                              self.present(alert, animated: true, completion: nil)
                                            
                          }
                                               
                      }
                      return
                  }
                  
                  
                  let ref = Database.database().reference().child("Doctor").child(user.uid)
                  
                  print("reached here")

                  ref.keepSynced(true)
                  ref.observeSingleEvent(of: .value) { (snapshot) in
                  
                      if snapshot.exists(){
                          
                          
                          
                             if let dict = snapshot.value as? [String: Any]{
                                
                                
                                let doctor_email = dict["email"] as? String ?? ""
                                let doctor_name = dict["name"] as? String ?? ""
                                let doctor_image = dict["image"] as? String ?? ""
                                let doctor_country = dict["country"] as? String ?? ""
                                let doctor_street = dict["street"] as? String ?? ""
                                let doctor_parish = dict["parish"] as? String ?? ""
                                let doctor_degree_info = dict["degree_type"] as? String ?? ""
                                let doctor_speciality = dict["specialization"] as? String ?? ""
                                let doctor_speciality_info = dict["other_specialization"] as? String ?? ""
                                let available_time = dict["available_time"] as? String ?? ""
                                let doctor_fee_label = dict["doctor_fee"] as? String ?? ""
                                let services_one = dict["services1"] as? String ?? ""
                                let services_two = dict["services2"] as? String ?? ""
                                let services_three = dict["services3"] as? String ?? ""
                                let services_four = dict["services4"] as? String ?? ""
                                let services_five = dict["services5"] as? String ?? ""
                              
                                 print("image",doctor_image)
                               Utils.saveDoctorLoginInfo(userid: user.uid,imageUrl: doctor_image)

                            Utils.saveDoctorInfo(email: doctor_email, name: doctor_name, country: doctor_country, street: doctor_street, parish: doctor_parish, degree_type: doctor_degree_info, specialization: doctor_speciality, available_time: available_time, service1: services_one, service2: services_two, service3: services_three, service4: services_four, service5: services_five, other_specialization: doctor_speciality_info, doctor_fee: doctor_fee_label)
                              

                              let storyBoard = UIStoryboard(name: "DoctorTabBar", bundle: nil)
                              let vc = storyBoard.instantiateViewController(withIdentifier: "doctorTabBar")

                              vc.modalPresentationStyle = .fullScreen

                              let transition = CATransition()
                              transition.duration = 0.5
                              transition.type = CATransitionType.push
                              transition.subtype = CATransitionSubtype.fromRight
                              transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                              self.view.window?.layer.add(transition, forKey: kCATransition)

                              self.view.window?.rootViewController = vc
                              
                              }
                              
                          
                      }

                  }
                  
              }
              
      
    }
    

    @IBAction func goBack_btn_tapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func patient_tapped(){
            mainView = false
                let window = UIApplication.shared.keyWindow
                transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
                transparentView.frame = self.view.frame
                window?.addSubview(transparentView)
                
                let screenSize = UIScreen.main.bounds.size
                tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
                window?.addSubview(tableView)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
                transparentView.addGestureRecognizer(tapGesture)
                
                transparentView.alpha = 0
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.transparentView.alpha = 0.5
                    self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
                }, completion: nil)
            
        
            
        }
    
    @objc func signup_doctor(){
        
        
        let name  = doctorSignupCell?.name.text ?? ""
        let password  = doctorSignupCell?.password.text ?? ""
        let email  = doctorSignupCell?.email.text ?? ""
        let degree_type  = doctorSignupCell?.degree_type.text ?? ""
        let specialization  = doctorSignupCell?.specialization.text ?? ""
        let country  = doctorSignupCell?.country ?? ""
        
        
        if name != "" && password != "" && email != "" && degree_type != "" && specialization != "" && country != ""{
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
             
             
             guard let user = result?.user, error == nil else {
                 if let error = error {
                     let authError = error as NSError
                     if (authError.code == AuthErrorCode.emailAlreadyInUse.rawValue) {
                                       
                         let alert = UIAlertController(title: "Doctor Info Already Exists", message: "Info For Doctor already exists", preferredStyle: .alert)
                         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                         alert.addAction(action)


                         self.present(alert, animated: true, completion: nil)
                                       
                     }
                                          
                 }
                 return
             }
                
                let ref = Database.database().reference().child("Doctor").child(user.uid)

                print("email: ", email," country: ", country, " name: ",name, " password: ",password, " userid:" ,user.uid)
                                       ref.keepSynced(true)
                                       ref.observeSingleEvent(of: .value) { (snapshot) in
                                       
                                           let doctorSignupObject = ["name": name,
                                                                      "email": email,
                                                                      "degree_type": degree_type,
                                                                      "specialization" : specialization,
                                                                      "country": country] as [String : Any]

                                           ref.updateChildValues(doctorSignupObject) { (error, reference) in

                                            
                                            Utils.saveDoctorLoginInfo(userid: user.uid,imageUrl: "")

                                               Utils.saveDoctorInfo(email: email, name: name, country: country, street: "", parish: "", degree_type: degree_type, specialization: specialization, available_time: "", service1: "", service2: "", service3: "", service4: "", service5: "", other_specialization: "", doctor_fee: "")
                                               
                                               //self.patientSignupCell?.shapeLayer.removeFromSuperlayer()

                                              let storyBoard = UIStoryboard(name: "DoctorTabBar", bundle: nil)
                                               let vc = storyBoard.instantiateViewController(withIdentifier: "doctorTabBar")

                                               vc.modalPresentationStyle = .fullScreen

                                               let transition = CATransition()
                                               transition.duration = 0.5
                                               transition.type = CATransitionType.push
                                               transition.subtype = CATransitionSubtype.fromRight
                                               transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                                               self.view.window?.layer.add(transition, forKey: kCATransition)

                                               self.view.window?.rootViewController = vc
                                           }

                                       }
                
                
            }
            
        }
        
        
        
        
    }
        
        @objc func onClickTransparentView() {
            if !self.keyboardIsShowing{
                let screenSize = UIScreen.main.bounds.size
                mainView = true
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.transparentView.alpha = 0
                    self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
                }, completion: nil)
            }else{
//                patientSignupCell?.endEditing(true)
//                patientLoginCell?.endEditing(true)
                
                self.keyboardIsShowing = false
            }
        }
    }


extension DoctorLoginViewController: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 1
           }

           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorSignupCell") as! DoctorSignuptableViewCell
           
            doctorSignupCell = cell
            
            cell.signup_btn.addTarget(self, action: #selector(signup_doctor), for: .touchUpInside)
            
               return cell
           }

           
           
            func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
           {
               let verticalPadding: CGFloat = 8

               let maskLayer = CALayer()
               maskLayer.cornerRadius = 20    //if you want round edges
               maskLayer.backgroundColor = UIColor.white.cgColor
               maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 5, dy: verticalPadding/2)
               cell.layer.mask = maskLayer
           }
        
        
        
        
        
        
        
    }


