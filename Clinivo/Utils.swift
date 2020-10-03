//
//  Utils.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import Kingfisher
class Utils {
    
    
    
    public static func reg(cell : String, nibName: String, tableView: UITableView) {
           
           tableView.register(UINib.init(nibName: nibName, bundle: nil), forCellReuseIdentifier: cell)
           
          
       }
    
    
    public static func savePatientInfo(email : String, name : String, country: String,dob: String, street: String, city: String, parish: String){
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
         let _ = keychain.set(email, forKey: "email")
         let _ = keychain.set(name, forKey: "name")
        let _ = keychain.set(country, forKey: "country")
        let _ = keychain.set(dob, forKey: "dob")
        let _ = keychain.set(street, forKey: "street")
        let _ = keychain.set(city, forKey: "city")
        let _ = keychain.set(parish, forKey: "parish")
        
    }
    
    public static func saveDoctorLoginInfo(userid: String, imageUrl: String){
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        let _ = keychain.set(userid, forKey: "doctor_userid")
        let _ = keychain.set(imageUrl, forKey: "doctor_imageUrl")
        
    }
    
    public static func saveDoctorInfo(email : String, name : String, country: String, street: String, parish: String,degree_type: String,specialization: String, available_time: String,service1: String,service2: String,service3: String,service4: String,service5: String, other_specialization: String,doctor_fee: String){
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
         let _ = keychain.set(email, forKey: "doctor-email")
         let _ = keychain.set(name, forKey: "doctor-name")
        let _ = keychain.set(country, forKey: "doctor-country")
        let _ = keychain.set(degree_type, forKey: "doctor-degree_type")
        let _ = keychain.set(street, forKey: "doctor-street")
        let _ = keychain.set(specialization, forKey: "doctor-specialization")
        let _ = keychain.set(parish, forKey: "doctor-parish")
        let _ = keychain.set(email, forKey: "doctor-email")
                let _ = keychain.set(available_time, forKey: "doctor-available_time")
               let _ = keychain.set(service1, forKey: "doctor-service1")
               let _ = keychain.set(service2, forKey: "doctor-service2")
               let _ = keychain.set(service3, forKey: "doctor-service3")
               let _ = keychain.set(service4, forKey: "doctor-service4")
               let _ = keychain.set(service5, forKey: "doctor-service5")
        
        let _ = keychain.set(other_specialization, forKey: "doctor-other_specialization")
        let _ = keychain.set(doctor_fee, forKey: "doctor-doctor_fee")
    }
    
    public static func getDoctorImage() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor_imageUrl") ?? ""
    }
    
    public static func getDoctorAvailable_time() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-available_time") ?? ""
       }
       
       public static func  getDoctorService1() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-service1") ?? ""
       }
       
       
       public static func  getDoctorService2() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-service2") ?? ""
       }
       
       public static func  getDoctorService3() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-service3") ?? ""
       }
       
       public static func  getDoctorService4() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-service4") ?? ""
       }
       
       public static func  getDoctorService5() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-service5") ?? ""
       }
       
       public static func  getDoctorOther_specialization() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-other_specialization") ?? ""
       }
       
       public static func getDoctorDoctor_fee() -> String{
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
           return keychain.get("doctor-doctor_fee") ?? ""
       }
    
    
    public static func  getDoctorName() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-name") ?? ""
    }
    
    
    public static func  getDoctorCountry() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-country") ?? ""
    }
    
    public static func  getDoctorDegree_type() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-degree_type") ?? ""
    }
    
    public static func  getDoctorStreet() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-street") ?? ""
    }
    
    public static func  getDoctorSpecialization() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-specialization") ?? ""
    }
    
    public static func  getDoctorParish() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor-parish") ?? ""
    }
    
    public static func getDoctorUserid() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("doctor_userid") ?? ""
    }
    
        
    
    public static func getPatientEmail() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("email") ?? ""
    }
    
    public static func getPatientName() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("name") ?? ""
    }
    
    
    public static func getPatientCountry() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("country") ?? ""
    }
    
    public static func getPatientDOB() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("dob") ?? ""
    }
    
    public static func getPatientStreet() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("street") ?? ""
    }
    
    public static func getPatientCity() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("city") ?? ""
    }
    
    public static func getPatientParish() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("parish") ?? ""
    }
    
    public static func getPatientUserid() -> String{
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        return keychain.get("patient_userid") ?? ""
    }
    
    public static func savePatientLoginInfo(email : String,userid: String){
        let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
         let _ = keychain.set(email, forKey: "email")
        let _ = keychain.set(userid, forKey: "patient_userid")
        
    }
    
    
    public static func savePatientSignupInfo(email : String, name : String, country: String, userid: String){
           let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
            let _ = keychain.set(email, forKey: "email")
            let _ = keychain.set(name, forKey: "name")
           let _ = keychain.set(country, forKey: "country")

        let _ = keychain.set(userid, forKey: "patient_userid")
        
        
           
       }
    
    public static func clear(){
              let keychain = KeychainSwift(keyPrefix: "clinivo-keys")
        keychain.clear()
           
              
          }
    
    
    
    
    
    
}

extension UIView{
    
    func applyShadow() {
       
        self.layer.borderWidth = 1
//        self.layer.borderColor = Colors.light_grey().cgColor //changes button/views outlines to light gray
        
        self.layer.borderColor = self.backgroundColor?.cgColor //changes button outlines to background color of buttons/views
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.85
        
        self.layer.masksToBounds = false
        
    }
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.

     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.35) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = .identity
            }) { (animationCompleted: Bool) -> Void in
        }
    }


    /**
     Zoom in any view with specified offset magnification.

     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.35, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                    self.transform = .identity
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }

    
}

extension UIViewController{
func hideKeyBoardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    
    tap.cancelsTouchesInView = false
    
    view.addGestureRecognizer(tap)
}

func tableViewDismissKeyBoard(tableView: UITableView) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    
    tap.cancelsTouchesInView = false
    tableView.addGestureRecognizer(tap)
}
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}

extension UIImageView{
    
    
    func setImage(imageUrl: URL){
       
        DispatchQueue.global(qos: .default).async {
            let cache = ImageCache.default


            cache.cleanExpiredDiskCache()
            cache.cleanExpiredMemoryCache()
            
            

        }
        
        

        let processor = DownsamplingImageProcessor(size: self.frame.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: imageUrl,
            placeholder: #imageLiteral(resourceName: " placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .fromMemoryCacheOrRefresh,
                .cacheOriginalImage,
                .memoryCacheExpiration(.seconds(86400)),
                .diskCacheExpiration(.seconds(86400)),
                .downloader(ImageDownloader(name: "Clinivo-Images")),
                .processingQueue(.dispatch(.global(qos: .default))),
                .callbackQueue(.dispatch(.global(qos: .default)))
            ])

       
    }
    
    
}
