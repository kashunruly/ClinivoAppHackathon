//
//  ViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var doctor_login_btn: UIButton!
    @IBOutlet weak var pateient_member_login_btn: UIButton!
    
    
    
    @IBOutlet weak var patient_signup_btn: UIButton!
    var transparentView = UIView()
    var tableView = UITableView()
    var height: CGFloat = 450
    
    var type = ""
    var keyboardHeight: CGFloat = 0
    
    var patientSignupCell: PatientTableViewCell?
    var patientLoginCell: PatientTableViewCell?
    
    var keyboardIsShowing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissCellKeyboard))
           
           tap.cancelsTouchesInView = false
           
           view.addGestureRecognizer(tap)
        
        
        self.hideKeyBoardWhenTappedAround()
        
        
       
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 237/255, alpha: 1)
        
        
        Utils.reg(cell: "PatientCell", nibName: "PatientCell", tableView: tableView)
        
        
        Utils.reg(cell: "PatientLoginCell", nibName: "PatientLoginCell", tableView: tableView)
        
        
        
        
        if let _ = doctor_login_btn{
            doctor_login_btn.layer.cornerRadius = 22.5
            doctor_login_btn.applyShadow()
            pateient_member_login_btn.layer.cornerRadius = 22.5
            pateient_member_login_btn.applyShadow()
            
            patient_signup_btn.layer.cornerRadius = 22.5
            patient_signup_btn.applyShadow()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        }
        
        
    }
    
    @objc func dismissCellKeyboard(){
        patientSignupCell?.endEditing(true)
        patientLoginCell?.endEditing(true)
        self.keyboardIsShowing = false
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
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
    
   

    @objc func keyboardWillHide(sender: NSNotification) {
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

    
    @IBAction func doctor_btn_tapped(_ sender: Any) {
        
        doctor_login_btn.zoomIn()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorLogin")
        
        vc.modalPresentationStyle = .pageSheet
        
        self.show(vc, sender: self)
        
        
        
    }
    
    @IBAction func patient_member_btn_tapped(_ sender: Any) {
        pateient_member_login_btn.zoomIn()
        height = 350
        type = "patient_login"
        tableView.reloadData()
        patient_tapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize = UIScreen.main.bounds.size
        self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
    }
    
    @IBAction func patient_signup_btn_tapped(_ sender: Any) {
        patient_signup_btn.zoomIn()
        height = 450
        type = "patient_signup"
         tableView.reloadData()
        patient_tapped()
    }
    
    
    
    
    
    
    @objc func patient_login(){
        
        patientLoginCell?.login_btn.zoomIn()
        patientLoginCell?.statusSpinner()
        
        if patientLoginCell?.email.text ?? "" != "" && patientLoginCell?.password.text ?? "" != ""{
            
            let email = self.patientLoginCell?.email.text ?? ""
            let password = self.patientLoginCell?.password.text ?? ""
            
            
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
                
                
                let ref = Database.database().reference().child("Patient").child(user.uid)
                
                print("reached here")

                ref.keepSynced(true)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                
                    if snapshot.exists(){
                        
                        
                        
                           if let dict = snapshot.value as? [String: String]{
                            
                               // dict: ["dob": May 29, 2005, "name": kashlon palmer, "street": Wait A bit, "parish": trelawny, "password": 123456, "email": kash@gmail.com, "country": Jamaica, "city": Wait A bit]
                            
                            self.patientLoginCell?.endEditing(true)
                            Utils.savePatientLoginInfo(email: email, userid: user.uid)
                            Utils.savePatientInfo(email: email, name: dict["name"] ?? "", country: dict["country"] ?? "", dob: dict["dob"] ?? "", street: dict["street"] ?? "", city: dict["city"] ?? "", parish: dict["parish"] ?? "")
                            
                            self.patientSignupCell?.shapeLayer.removeFromSuperlayer()

                            let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "patientTabBar")

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
        
        
        
        
    }
    
    
    @objc func patient_signup(){
        
        patientSignupCell?.signup_btn.zoomIn()
        patientSignupCell?.statusSpinner()
        
        if patientSignupCell?.country ?? "" != "" && patientSignupCell?.name.text ?? ""  != "" && patientSignupCell?.signup_email.text ?? "" != "" && patientSignupCell?.password.text ?? "" != ""{
            
            
            let email = self.patientSignupCell?.signup_email.text ?? ""
            let password = self.patientSignupCell?.password.text ?? ""
            let country = self.patientSignupCell?.country ?? ""
            let name = self.patientSignupCell?.name.text ?? ""
            
            print("here email: ", email," country: ", country, " name: ",name, " password: ",password)
            
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                       
                        
                        
                        guard let user = result?.user, error == nil else {
                            if let error = error {
                                let authError = error as NSError
                                if (authError.code == AuthErrorCode.emailAlreadyInUse.rawValue) {
                                                  
                                    let alert = UIAlertController(title: "Patient Info Already Exists", message: "Info For Patient already exists", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                                    alert.addAction(action)


                                    self.present(alert, animated: true, completion: nil)
                                                  
                                }
                                                     
                            }
                            return
                        }
                                               
                         let ref = Database.database().reference().child("Patient").child(user.uid)

                        print("email: ", email," country: ", country, " name: ",name, " password: ",password)
                        ref.keepSynced(true)
                        ref.observeSingleEvent(of: .value) { (snapshot) in
                        
                            let patientSignupObject = ["name": name,
                                                       "email": email,
                                                       "country": country] as [String : Any]

                            ref.updateChildValues(patientSignupObject) { (error, reference) in

                                Utils.savePatientSignupInfo(email: email, name: name, country: country,userid: user.uid)
                                
                                self.patientSignupCell?.shapeLayer.removeFromSuperlayer()

                                let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "patientTabBar")

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
    
    
    
    @objc func patient_tapped(){
        
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
    
    @objc func onClickTransparentView() {
        if !self.keyboardIsShowing{
            let screenSize = UIScreen.main.bounds.size

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            }, completion: nil)
        }else{
            patientSignupCell?.endEditing(true)
            patientLoginCell?.endEditing(true)
            self.keyboardIsShowing = false
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: PatientTableViewCell
        
        
        if type == "patient_login"{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "PatientLoginCell", for: indexPath) as! PatientTableViewCell
            //           cell.popUp_text.text = settingArray[indexPath.row]
            //           if indexPath.row == 0{
            //               cell.popUp_image.image = UIImage(named: "gallery_empty_view_image.png")
            //               cell.name = "gallery"
            //           }else{
            //              cell.popUp_image.image = #imageLiteral(resourceName: "ic_delete")
            //               cell.name = "remove"
            //           }
            //
            //           cell.cellTappedDelegate = self
                    
                    patientLoginCell = cell
                    
                    
                    cell.login_btn.addTarget(self, action: #selector(patient_login), for: .touchUpInside)
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientTableViewCell
            //           cell.popUp_text.text = settingArray[indexPath.row]
            //           if indexPath.row == 0{
            //               cell.popUp_image.image = UIImage(named: "gallery_empty_view_image.png")
            //               cell.name = "gallery"
            //           }else{
            //              cell.popUp_image.image = #imageLiteral(resourceName: "ic_delete")
            //               cell.name = "remove"
            //           }
            //
            //           cell.cellTappedDelegate = self
                    
                    patientSignupCell = cell
                    
                    
                    cell.signup_btn.addTarget(self, action: #selector(patient_signup), for: .touchUpInside)
        }
        
        
           return cell
       }

//       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return 450
//       }
       
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

