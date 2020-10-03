//
//  DoctorTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var doctor_image: UIImageView!
    
    @IBOutlet weak var doctor_name: UILabel!
    
    @IBOutlet weak var doctor_degree_info: UILabel!
    @IBOutlet weak var doctor_speciality_info: UILabel!
    
    @IBOutlet weak var doctor_fee_view: UIView!
    @IBOutlet weak var doctor_fee_label: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var available_time: UILabel!
    @IBOutlet weak var available_info_view: UIView!
    @IBOutlet weak var doctor_speciality: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doctor_image.layer.cornerRadius = 10
        
        doctor_speciality.layer.cornerRadius = 5
                   
        
        doctor_fee_view.layer.cornerRadius = 10
        doctor_fee_view.applyShadow()
        
        available_info_view.layer.cornerRadius = 10
        available_info_view.applyShadow()
        
        
    }

    

}
