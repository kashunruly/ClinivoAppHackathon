//
//  DoctorModel.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol DoctorModelDelegate: class {
    
    func downloadedDoctors(doctors: [Doctor])
   
}





class DoctorModel: NSObject {
    
    var delegate : DoctorModelDelegate?
    
    
    
    
    var databaseHandle: DatabaseHandle?
     
    //var query: DatabaseQuery
         
    
    
    
    
    func loadDoctors(){
        
        let ref = Database.database().reference().child("Doctor")
        databaseHandle = ref.observe(.value) { (snapshot) in
            
            var doctorArray = [Doctor]()
            ref.keepSynced(true)
            
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any]{
                    
                    
                    
                    let dictkey = childSnapshot.key
                        
                    
                    let doctor = Doctor(doctor_userid: dictkey, doctor_name: dict["name"] as? String ?? "", doctor_image: dict["image"] as? String ?? "", doctor_degree_info: dict["degree_type"] as? String ?? "", doctor_speciality: dict["specialization"] as? String ?? "", doctor_speciality_info: dict["other_specialization"] as? String ?? "", available_time: dict["available_time"] as? String ?? "", doctor_fee_label: dict["doctor_fee"] as? String ?? "", location: dict["location"] as? String ?? "", services_one: dict["services1"] as? String ?? "", services_two: dict["services2"] as? String ?? "", services_three: dict["services3"] as? String ?? "", services_four: dict["services4"] as? String ?? "", services_five: dict["services5"] as? String ?? "")
                    
                 
                    doctorArray.append(doctor)
                    
                
                }
            }
            
            self.delegate?.downloadedDoctors(doctors: doctorArray)
            
            
            
        }
        
    
    }

}
