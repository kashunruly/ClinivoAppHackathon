//
//  WelcomeTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    var month: String = ""
    var day: String = ""
    var year: String = ""
    @IBOutlet weak var first_view: UIView!
    @IBOutlet weak var second_view: UIView!
    @IBOutlet weak var third_view: UIView!
    @IBOutlet weak var forth_view: UIView!
    @IBOutlet weak var fifth_view: UIView!
    
    @IBOutlet weak var first_image: UIImageView!
    @IBOutlet weak var second_image: UIImageView!
    @IBOutlet weak var third_image: UIImageView!
    @IBOutlet weak var forth_image: UIImageView!
    @IBOutlet weak var fifth_image: UIImageView!
    
    
    @IBOutlet weak var gender_picker: UIPickerView!
    
    let shapeLayer = CAShapeLayer()
    
     var gender:String = ""
    
    var pickerData: [String] = [String]()
    
     @IBOutlet weak var dob: UIDatePicker!
    @IBOutlet weak var city_address: UITextField!
    @IBOutlet weak var state_parish_address: UITextField!
    
    @IBOutlet weak var speak_with_doctor_btn: UIButton!
    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet weak var street_address: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let _ = first_view{
            
            speak_with_doctor_btn.layer.cornerRadius = 10
            
            speak_with_doctor_btn.applyShadow()
            
            first_view.layer.cornerRadius = 10
            second_view.layer.cornerRadius = 10
            third_view.layer.cornerRadius = 10
            forth_view.layer.cornerRadius = 10
            fifth_view.layer.cornerRadius = 10
            
            
            first_image.layer.cornerRadius = 10
            second_image.layer.cornerRadius = 10
            third_image.layer.cornerRadius = 10
            forth_image.layer.cornerRadius = 10
            fifth_image.layer.cornerRadius = 10
            
            
            first_view.applyShadow()
            second_view.applyShadow()
            third_view.applyShadow()
            forth_view.applyShadow()
            fifth_view.applyShadow()
            
        }
        
        if let _ = save_btn{
            save_btn.layer.cornerRadius = 20
            save_btn.applyShadow()
            
            city_address.delegate = self
            state_parish_address.delegate = self
            street_address.delegate = self
            
            city_address.applyShadow()
            state_parish_address.applyShadow()
            street_address.applyShadow()
            
            
        }
        
        if let _ = gender_picker{
            self.gender_picker.delegate = self
            self.gender_picker.dataSource = self
            
            pickerData = ["Select Your Gender","Male", "Female"]
        }
        
        
        
    }

    
    @IBAction func dobPickerChange(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy"
         year = dateFormatter.string(from: self.dob.date)
        dateFormatter.dateFormat = "MM"
         month = dateFormatter.string(from: self.dob.date)
        dateFormatter.dateFormat = "dd"
         day = dateFormatter.string(from: self.dob.date)
        
        switch month {
        case "01":
            month = "January"
            break;
            
        case "02":
        month = "February"
        break;
            
        case "03":
        month = "March"
        break;
        
        case "04":
        month = "April"
        break;
            
        case "05":
        month = "May"
        break;
            
        case "06":
        month = "June"
        break;
            
        case "07":
        month = "July"
        break;
            
        case "08":
        month = "August"
        break;
            
        case "09":
        month = "September"
        break;
            
        case "10":
        month = "October"
        break;
            
        case "11":
        month = "November"
        break;
            
        case "12":
        month = "December"
        break;
            
        default:
            month = ""
        }
        
     
        
    }
    
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      // The number of rows of data
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return pickerData.count
      }
      
      // The data to return fopr the row and component (column) that's being passed in
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return pickerData[row]
      }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           // This method is triggered whenever the user makes a change to the picker selection.
           // The parameter named row and component represents what was selected.
        
        gender = pickerData[row] as String
        
        if gender == "Select Your Gender" {
            gender = ""
        }
    
       
       }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           

           textField.resignFirstResponder()
           
           return true
           
       }
    
    
    func statusSpinner(){
        
        self.shapeLayer.isHidden = false
        
     let height = self.frame.height
     let width = self.frame.width
         
        let center = CGPoint(x: width / 2, y: height / 2)
         
        let aquaInspireColor = UIColor(red: 150, green: 237, blue: 249, alpha: 1)
         
         // create track layer
         
         let circularPath = UIBezierPath(arcCenter: center, radius: 60, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
         
         ///
         
         
         shapeLayer.lineCap = CAShapeLayerLineCap.round
         //shapeLayer.lineDashPhase = 10
         
         shapeLayer.path = circularPath.cgPath
         shapeLayer.fillColor = UIColor.clear.cgColor
         
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
         shapeLayer.lineWidth = 7
         shapeLayer.strokeEnd = 0
         
         //anim
         
         let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
         
         basicAnimation.toValue = 1
         
        basicAnimation.duration = 1.5
         
         basicAnimation.isRemovedOnCompletion = false
         
        basicAnimation.repeatCount = Float.infinity
         
         shapeLayer.add(basicAnimation, forKey: "anim")
         
         self.layer.addSublayer(shapeLayer)
                    
    }

}
