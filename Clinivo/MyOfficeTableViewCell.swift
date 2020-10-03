//
//  MyOfficeTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import  MapKit

class MyOfficeTableViewCell: UITableViewCell {
    
    
   @IBOutlet weak var doctor_image: UIImageView!
    
    @IBOutlet weak var doctor_name: UILabel!
    
    @IBOutlet weak var doctor_degree_info: UILabel!
    @IBOutlet weak var doctor_speciality_info: UILabel!
    
    @IBOutlet weak var map_view: UIView!
    @IBOutlet weak var doctor_fee_view: UIView!
    @IBOutlet weak var doctor_fee_label: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var available_time: UILabel!
    @IBOutlet weak var available_info_view: UIView!
    @IBOutlet weak var doctor_speciality: UILabel!
    
    @IBOutlet weak var services_one: UILabel!
    @IBOutlet weak var services_two: UILabel!
    @IBOutlet weak var services_three: UILabel!
    @IBOutlet weak var services_four: UILabel!
    @IBOutlet weak var services_five: UILabel!
    
    @IBOutlet weak var location_map: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doctor_image.layer.cornerRadius = 10
        
        doctor_speciality.layer.cornerRadius = 5
                   
        
        doctor_fee_view.layer.cornerRadius = 10
        doctor_fee_view.applyShadow()
        
        available_info_view.layer.cornerRadius = 10
        available_info_view.applyShadow()
        
        location_map.layer.cornerRadius = 10
        map_view.layer.cornerRadius = 10
        map_view.applyShadow()
        
    }


}
