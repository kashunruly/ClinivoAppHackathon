//
//  DoctorSignuptableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class DoctorSignuptableViewCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var dismiss_btn: UILabel!
    @IBOutlet weak var country_picker: UIPickerView!
    let shapeLayer = CAShapeLayer()
    var country = ""
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
     @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var degree_type: UITextField!
    @IBOutlet weak var specialization: UITextField!
    
    @IBOutlet weak var signup_btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        email.delegate = self
        name.delegate = self
        password.delegate = self
        degree_type.delegate = self
        specialization.delegate = self
        
        country_picker.delegate = self
        
        country_picker.dataSource = self
        
        signup_btn.layer.cornerRadius = 15
        signup_btn.applyShadow()
    }
    
    
    // Number of columns of data
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
             return 1
         }
         
         // The number of rows of data
         func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return Constants.COUNTRIES.count
         }
         
         // The data to return fopr the row and component (column) that's being passed in
         func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return Constants.COUNTRIES[row]
         }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
              // This method is triggered whenever the user makes a change to the picker selection.
              // The parameter named row and component represents what was selected.
           
            country = Constants.COUNTRIES[row] as String
           
           if country == Constants.COUNTRIES[0] as String {
               country = ""
               
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
