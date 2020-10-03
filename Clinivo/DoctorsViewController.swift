//
//  DoctorsViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class DoctorCellTapGesture: UITapGestureRecognizer {
    
    var doctor = Doctor()
    
}

class DoctorsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,DoctorModelDelegate, UIGestureRecognizerDelegate {
    
    
   var doctorArray = [Doctor]()
    
    let doctorModel = DoctorModel()
    
    @IBOutlet weak var myDoctors_btn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        doctorModel.delegate = self
        
        doctorModel.loadDoctors()
        
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 262
        
        Utils.reg(cell: "DoctorCell", nibName: "DoctorCell", tableView: tableView)
        
    
    }
    
    
    func downloadedDoctors(doctors: [Doctor]) {
        doctorArray = doctors
        
        tableView.reloadData()
    }
    
    @IBAction func myDoctors_btn_tapped(_ sender: Any) {
        
        
    }
    
    
    @objc func goToSpeak(sender: DoctorCellTapGesture){
        
        print("doctor userid:", sender.doctor.doctor_userid)
        
        let storyBoard = UIStoryboard(name: "DoctorChat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "doctorChat") as! DoctorChatViewController

        vc.modalPresentationStyle = .fullScreen
        vc.doctor = sender.doctor
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for:  indexPath) as! DoctorTableViewCell
        
        print("doctor id: ",doctorArray[indexPath.row].doctor_userid)
        
        if self.doctorArray[indexPath.row].doctor_image != ""{


            if let url = URL(string: self.doctorArray[indexPath.row].doctor_image ){

                cell.doctor_image.setImage(imageUrl: url)

            }


        }
        
        cell.doctor_name.text = "Dr. \(doctorArray[indexPath.row].doctor_name.capitalized)"
        
        cell.doctor_speciality.text = doctorArray[indexPath.row].doctor_speciality
        
        cell.doctor_degree_info.text = doctorArray[indexPath.row].doctor_degree_info
        
        let tap = DoctorCellTapGesture(target: self, action: #selector(goToSpeak(sender:)))
        
        tap.numberOfTapsRequired = 1
        
        tap.doctor = doctorArray[indexPath.row]
        
        tap.delegate = self
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(tap)
        
            cell.contentView.alpha = 0
            return cell
           
       }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
        
        let verticalPadding: CGFloat = 16

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20    //if you want round edges
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 5, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    

}
