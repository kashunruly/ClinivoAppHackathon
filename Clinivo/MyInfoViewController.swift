//
//  MyInfoViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyInfoViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var count = 1
    
    
    var infoCell: WelcomeTableViewCell?
    var myInfoCell: MyInfoTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 226
        
        tableView.separatorStyle = .none
        
        Utils.reg(cell: "MyInfoCell", nibName: "MyInfoCell", tableView: tableView)
        Utils.reg(cell: "InfoCell", nibName: "InfoCell", tableView: tableView)
    }
    
    @objc func edit_info(){
        
        if myInfoCell?.edit_info_btn.titleLabel?.text ?? "" == "Edit Info"{
            count = 2
        }else{
            count = 1
        }
        
    
        
        tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyInfoCell") as! MyInfoTableViewCell
            
            myInfoCell = cell
            cell.paient_name.text = Utils.getPatientName().capitalized
            if Utils.getPatientCountry() == ""{
                cell.country.text = "N/A"
            }else{
                cell.country.text = Utils.getPatientCountry()
            }
            
            if Utils.getPatientDOB() == ""{
                cell.dob.text = "N/A"
            }else{
                cell.dob.text = Utils.getPatientDOB()
            }
            
            if Utils.getPatientStreet() == ""{
                cell.street.text = "N/A"
            }else{
                cell.street.text = Utils.getPatientStreet()
            }
            
            
            if Utils.getPatientCity() != "" && Utils.getPatientParish() != ""{
                cell.city_and_parish.text = "\(Utils.getPatientCity()), \(Utils.getPatientParish())"
            }else{
                if Utils.getPatientCity() == "" && Utils.getPatientParish() != ""{
                    
                    cell.city_and_parish.text = "N/A, \(Utils.getPatientParish())"
                }else if Utils.getPatientCity() != "" && Utils.getPatientParish() == ""{
                    cell.city_and_parish.text = "\(Utils.getPatientCity()), N/A"
                }else{
                    cell.city_and_parish.text = "N/A, N/A"
                }
                
                
            }
            
            if Utils.getPatientDOB() == ""{
                cell.age.text = "Age: N/A"
            }else{
                cell.age.text = "Age: 21"
            }
            
            cell.edit_info_btn.addTarget(self, action: #selector(edit_info), for: .touchUpInside)
            
            if count < 2{
                
                if cell.edit_info_btn.titleLabel?.text ?? "" == "Edit Info"{
                     cell.contentView.alpha = 0
                }
               
                cell.edit_info_btn.setTitle("Edit Info", for: .normal)
            }else{
                
                cell.edit_info_btn.setTitle("Cancel", for: .normal)
                
            }
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! WelcomeTableViewCell
                
                infoCell = cell
                cell.contentView.alpha = 0
                
                
                cell.save_btn.addTarget(self, action: #selector(save_info), for: .touchUpInside)
                
                 return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        UIView.animateKeyframes(withDuration: 0.75
            , delay: 0, options: .allowUserInteraction, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
        
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20    //if you want round edges
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 5, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
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
                    
                    self.count = 1
                    
                    
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

    


}
