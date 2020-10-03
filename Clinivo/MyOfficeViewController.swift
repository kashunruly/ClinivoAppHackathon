//
//  MyOfficeViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class MyOfficeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let button = UIButton.init(type: .custom)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        button.setTitle("Edit Office", for: .normal)
        button.backgroundColor = UIColor(red: 91/255, green: 28/255, blue: 70/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(red: 121/255, green: 206/255, blue: 244/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1
        button.applyShadow()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(self.edit_my_office), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 597
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        tableView.separatorStyle = .none
        Utils.reg(cell: "DoctorOfficeCell", nibName: "DoctorOfficeCell", tableView: tableView)
    }
    
    @objc func edit_my_office(){
        button.zoomIn()
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorOfficeCell") as! MyOfficeTableViewCell
        
        if Utils.getDoctorUserid() != ""{
            
            print("image:",Utils.getDoctorImage())
            if Utils.getDoctorImage() != ""{
                
                if let url = URL(string: Utils.getDoctorImage()){

                    cell.doctor_image.setImage(imageUrl: url)

                }
            }
            
            cell.doctor_name.text = Utils.getDoctorName()
            
            cell.doctor_degree_info.text = Utils.getDoctorDegree_type()
            
            cell.doctor_speciality.text = Utils.getDoctorSpecialization()
            
//            cell.doctor_speciality_info.text = Utils.getDoctorOther_specialization()
            
//            cell.available_time.text = Utils.getDoctorAvailable_time()
//
//            cell.doctor_fee_label.text = "USD $\(Utils.getDoctorDoctor_fee())"
//
//            cell.location.text = "\(Utils.getDoctorStreet()), \(Utils.getDoctorParish())"
            
        //assigns services
//            cell.services_one.text = Utils.getDoctorService1()
//            cell.services_two.text = Utils.getDoctorService2()
//            cell.services_three.text = Utils.getDoctorService3()
//            cell.services_four.text = Utils.getDoctorService4()
//            cell.services_five.text = Utils.getDoctorService5()
        }
        
        
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
