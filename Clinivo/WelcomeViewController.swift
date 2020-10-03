//
//  WelcomeViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class WelcomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcome_nav_item: UINavigationItem!
    
    var infoCell: WelcomeTableViewCell?
    
    
    var temp = 0
    
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: "escape") {
                button.setImage(image, for: .normal)
                button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
            }
        } else {
            button.setTitle("Logout", for: .normal)
        }
        button.backgroundColor = UIColor(red: 91/255, green: 28/255, blue: 70/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(red: 121/255, green: 206/255, blue: 244/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1
        button.applyShadow()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(self.logout_btn_tapped), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        if let range = Utils.getPatientName().range(of: " ") {
            let name = "\(Utils.getPatientName()[...range.lowerBound])"
            welcome_nav_item.title = "Welcome \(name.capitalized)"
        }

        
        
        if Utils.getPatientCity() == ""{
            temp = 1
        }
        
        Utils.reg(cell: "WelcomeCell", nibName: "WelcomeCell", tableView: tableView)
        Utils.reg(cell: "InfoCell", nibName: "InfoCell", tableView: tableView)
        
    }
    
   @objc func logout_btn_tapped() {
    
    button.zoomIn()
    
    do{
        try Auth.auth().signOut()
    }catch{
        print("error loging out")
    }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "MainVC")
        
        vc.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
    
        view.window?.rootViewController = vc
        
        Utils.clear()
    

        
        
    }
    
    @objc func save_info(){
        
        infoCell?.statusSpinner()
        infoCell?.save_btn.zoomIn()
        
        let month = infoCell?.month ?? ""
        let day = infoCell?.day ?? ""
        let year = infoCell?.year ?? ""
        
        let dob = "\(month) \(day), \(year)"
        
        let street = infoCell?.street_address.text ?? ""
        let city = infoCell?.city_address.text ?? ""
        let parish = infoCell?.state_parish_address.text ?? ""
        
        if month != "" && day != "" && year != "" && street != "" && city != "" && parish != ""{
            
            let ref = Database.database().reference().child("Patient").child(Utils.getPatientUserid())

            ref.keepSynced(true)
            ref.observeSingleEvent(of: .value) { (snapshot) in
            
                let patientSignupObject = ["dob": dob,
                                           "street": street,
                                           "city": city,
                                           "parish": parish] as [String : Any]

                ref.updateChildValues(patientSignupObject) { (error, reference) in

                    Utils.savePatientInfo(email: Utils.getPatientEmail(), name: Utils.getPatientName(), country: Utils.getPatientCountry(), dob: dob, street: street, city: city, parish: parish)
                    
                    self.infoCell?.shapeLayer.removeFromSuperlayer()
                    
                    self.temp = 0
                    
                    
                    let alert = UIAlertController(title: "Patient Info Updated", message: "Your Info Updated Successfully", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.tableView.reloadData()
                    }

                    alert.addAction(action)


                    self.present(alert, animated: true, completion: nil)
                    
                    

                    
                }

            }
            
            
        }

        
        
    }
    
    
    @objc func speak_with_doctor(){
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if temp == 1{
             return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WelcomeTableViewCell
         
        if temp == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! WelcomeTableViewCell
            
            infoCell = cell
            cell.contentView.alpha = 0
            
            
            cell.save_btn.addTarget(self, action: #selector(save_info), for: .touchUpInside)
            
             return cell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell") as! WelcomeTableViewCell
            
            cell.contentView.alpha = 0
            
            
            cell.speak_with_doctor_btn.addTarget(self, action: #selector(speak_with_doctor), for: .touchUpInside)
            
             return cell
        }
        
       
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        UIView.animateKeyframes(withDuration: 1.25, delay: 0, options: .allowUserInteraction, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
        
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20    //if you want round edges
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 5, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    

   

}
