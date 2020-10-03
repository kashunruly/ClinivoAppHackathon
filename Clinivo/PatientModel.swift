//
//  PatientModel.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/30/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol PatientDelegate: class {
    func downloadPatient(patients: [Patient])
}

class PatientModel: NSObject {
    
    
    var patientDelegate: PatientDelegate?
    
    var patientArray = [Patient]()
    
    func loadMyPatients(userid: String) {
        
        let patientRef = Database.database().reference().child("Messages").child(userid)
        
        
        patientRef.observe(.value) { (mainSnapshot) in
            patientRef.keepSynced(true)
            
            self.patientArray.removeAll()
            for child in mainSnapshot.children{
                
                if let childSnapshot = child as? DataSnapshot{
                    
                    let dictkey = childSnapshot.key
                    
                    print("key: ",dictkey)
                    
                    let patientRef2 = Database.database().reference().child("Patient").child(dictkey)
                    
                    patientRef2.keepSynced(true)
                    
                    
                    
                    patientRef2.observeSingleEvent(of: .value) { (snapshot) in
                        
                        
                        
                        if let dict = snapshot.value as? [String: String]{
                            
                            
                            let userid = snapshot.key
                           let name = dict["name"] ?? ""
                            let country = dict["country"] ?? ""
                            let dob = dict["dob"] ?? ""
                            let street = dict["street"] ?? ""
                            let city = dict["city"] ?? ""
                            let parish = dict["parish"] ?? ""
                            let email = dict["email"] ?? ""
                        
                           let patient = Patient(name: name, country: country, dob: dob, street: street,
                                                 city: city, parish: parish, email: email, patient_id: userid)
                            
                            self.patientArray.append(patient)
                            
                            if self.patientArray.count == mainSnapshot.childrenCount{
                                 self.patientDelegate?.downloadPatient(patients: self.patientArray)
                            }
                        
                        }
                        
                    }
                  
                }
                    
        
                
            }
            
           
        }
        
    }

}
