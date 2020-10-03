//
//  MyPatientsViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseAuth


class PatientCellTapGesture: UITapGestureRecognizer {
    
    var patient = Patient()
    
}


class MyPatientsViewController: UIViewController, PatientDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
   
    
    var patientArray = [Patient]()
    
    let patientModel = PatientModel()
    
    @IBOutlet weak var tableView: UITableView!
    
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
        button.applyShadow()
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(self.logout_btn_tapped), for: .touchUpInside)
        
        patientModel.patientDelegate = self
        
        patientModel.loadMyPatients(userid: Utils.getDoctorUserid())

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension
        
        
        Utils.reg(cell: "MyPatientCell", nibName: "MyPatientCell", tableView: tableView)
    }
    
    
    func downloadPatient(patients: [Patient]) {
        patientArray = patients
        
        print("count:", patients.count)
        
        tableView.reloadData()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPatientCell") as! MyPatientTableViewCell
        
        
        
        cell.paient_name.text = patientArray[indexPath.row].name.capitalized
        if patientArray[indexPath.row].country == ""{
            cell.country.text = "N/A"
        }else{
            cell.country.text = patientArray[indexPath.row].country
        }
        
        if patientArray[indexPath.row].dob == ""{
            cell.dob.text = "N/A"
        }else{
            cell.dob.text = patientArray[indexPath.row].dob
        }
        
        if patientArray[indexPath.row].street == ""{
            cell.street.text = "N/A"
        }else{
            cell.street.text = patientArray[indexPath.row].street
        }
        
        
        if patientArray[indexPath.row].city != "" && patientArray[indexPath.row].parish != ""{
            cell.city_and_parish.text = "\(patientArray[indexPath.row].city), \(patientArray[indexPath.row].parish)"
        }else{
            if patientArray[indexPath.row].city == "" && patientArray[indexPath.row].parish != ""{
                
                cell.city_and_parish.text = "N/A, \(patientArray[indexPath.row].parish)"
            }else if patientArray[indexPath.row].city != "" && patientArray[indexPath.row].parish == ""{
                cell.city_and_parish.text = "\(patientArray[indexPath.row].city), N/A"
            }else{
                cell.city_and_parish.text = "N/A, N/A"
            }
            
            
        }
        
        let tap = PatientCellTapGesture(target: self, action: #selector(goToSpeak(sender:)))
        
        tap.numberOfTapsRequired = 1
        
        tap.patient = patientArray[indexPath.row]
        
        tap.delegate = self
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(tap)
        
        
           return cell
       }
    
    @objc func goToSpeak(sender: PatientCellTapGesture){
           
           print("doctor userid:", sender.patient.patient_id)
           
           let storyBoard = UIStoryboard(name: "DoctorChat", bundle: nil)
           let vc = storyBoard.instantiateViewController(withIdentifier: "doctorChat") as! DoctorChatViewController

           vc.modalPresentationStyle = .fullScreen
           vc.patient = sender.patient
           
           self.present(vc, animated: true, completion: nil)
           
           
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

    


}
