//
//  DoctorChatViewController.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DoctorChatViewController: UIViewController,UITextViewDelegate,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,ConvoDelegate {
    
    
   
    
    
    
    var doctor = Doctor()
    var patient = Patient()
    
    var userid = ""
    var otheruserid = ""
    var sent = 0
    
    var convoArray = [Convo]()
    
    let convoModel = ConvoModel()
    
    var connected = false
    
    var firstLoad = 1
    
    var connectedRef: DatabaseReference?
    
    var connectHandle: DatabaseHandle?
    
    var onlineRef: DatabaseReference?
    var onlineHandle: DatabaseHandle?
    
    var connecting = false
    
    var keyboardHeight: CGFloat = 0
    
    
    var timer: Timer?
    
    var typing = false
    
    var userTypingExist = false
    
    var textTimer: Timer?
    
    var online = ""
    
    var tableView_origin = 0
    var message_con_origin = 0
    
    
    var card_url = ""
    
    @IBOutlet weak var doctor_image: UIImageView!
    @IBOutlet weak var send_constraint: NSLayoutConstraint!
       
    @IBOutlet weak var tableView_top: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var send_btn_con: UIView!
    @IBOutlet weak var more_options_con: UIView!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var message_body: UITextView!
    @IBOutlet weak var more_options_btn: UIButton!
    @IBOutlet weak var online_typing: UILabel!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        send_btn_con.layer.cornerRadius = 22.5
        send_btn_con.applyShadow()
        more_options_con.layer.cornerRadius = 22.5
        more_options_con.applyShadow()
        
        message_body.layer.cornerRadius = 10
        
        if Utils.getPatientUserid() != ""{
            name.text = "Dr. \(doctor.doctor_name.capitalized)"
            userid = Utils.getPatientUserid()
            otheruserid = doctor.doctor_userid
            
            doctor_image.layer.cornerRadius = 20
            
        }else{
            
            name.text = patient.name.capitalized
            userid = Utils.getDoctorUserid()
            otheruserid = patient.patient_id
            
            doctor_image.widthAnchor.constraint(equalToConstant: 0).isActive = true
            
            view.layoutIfNeeded()
            
        }
        
        let cardRef = Database.database().reference().child("CardURL")
        
        cardRef.observeSingleEvent(of: .value) { (snapshot) in
            
            
            
            if let dict = snapshot.value as? [String: Any]{
                self.card_url = dict["url"] as? String ?? ""
            }
            
            
            
        }
        
        if self.doctor.doctor_image != ""{


                   if let url = URL(string: self.doctor.doctor_image){

                    doctor_image.setImage(imageUrl: url)

                   }


               }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.alpha = 0
        
        convoModel.convoDelegate = self
        
        convoModel.loadConvo(userid: userid, otheruserid: otheruserid)
        
        self.tableViewDismissKeyBoard(tableView: tableView)
        
        message_body.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        internetPresense()
        
        
        Utils.reg(cell: "RightCell", nibName: "RightCell", tableView: tableView)
        Utils.reg(cell: "LeftCell", nibName: "LeftCell", tableView: tableView)
        
    }
    
    func downloadConvo(convos: [Convo]) {
        
        convoArray = convos
        tableView.reloadData()
        
        if self.firstLoad == 1{
            if self.convoArray.count > 0{
                self.scrollToBottom()
            }
            self.firstLoad = 0
        }
        
        let height = self.tableView.frame.size.height
        let contentYoffset = self.tableView.contentOffset.y
        let distanceFromBottom = self.tableView.contentSize.height - contentYoffset - (height / 2)
               if distanceFromBottom < height {
                    self.scrollToBottom()
               }
        
        print("distance: ",distanceFromBottom)
         print("distance height: ", height)
               
        
        if self.sent == 1{
            self.scrollToBottom()
            self.sent = 0
        }
        
       
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.tableView.alpha = 1
        }, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convoArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: DoctorChatTableViewCell
            
        
        if convoArray[indexPath.row].sender == userid{
            cell = tableView.dequeueReusableCell(withIdentifier: "RightCell") as! DoctorChatTableViewCell
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell") as! DoctorChatTableViewCell
        }
        
        cell.messageText.text = convoArray[indexPath.row].message
   
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
    

    @IBAction func back_btn_tapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send_btn_tapped(_ sender: Any) {
        send_btn_con.zoomIn()
        if self.connected == false{
            goOnline()
        }
        
            if message_body.text != "" {
                
                self.send_message()
                
            }
        
    }

    @IBAction func more_opetions_btn_tapped(_ sender: Any) {
        more_options_con.zoomIn()
        
        let alert = UIAlertController(title: "More Options", message: "View Options Below", preferredStyle: .actionSheet)
              
        if Utils.getPatientUserid() != ""{
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Pay With Card", comment: ""), comment: "Default action"), style: .default, handler: { (alert) in
                    
                      let storyboard: UIStoryboard = UIStoryboard(name: "Web", bundle: nil)
                                    
                      let vc = storyboard.instantiateViewController(withIdentifier: "webView") as! WebViewController
                      vc.modalPresentationStyle = .fullScreen
                    
                    if self.doctor.doctor_fee_label != ""{
                        vc.url = "\(self.card_url)?amount=\(self.doctor.doctor_fee_label)"
                    }else{
                        vc.url = "\(self.card_url)?amount=20"
                    }
                    
                      self.present(vc, animated: true, completion: nil)
                         
                  }))
             
            
                   
                  alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Pay with Paypal", comment: ""), comment: "Default action"), style: .default,  handler: { (alert) in
                       
                    
                       
                   }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Request To Pay upon prescripting pickup ", comment: ""), comment: "Default action"), style: .default,  handler: { (alert) in
                
             
                
            }))
                  
                  
                   
                  alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Make Appointment", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
                alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Request prescription be sent to a particular pharmacy", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Send Photo", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Cancel", comment: ""), comment: "Default action"), style: .cancel,  handler: nil))
             
        }else{
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Request Image of Condition", comment: ""), comment: "Default action"), style: .default, handler: { (alert) in
                    
                         
                  }))
            
                alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Write prescription and send to patient's pharmacy", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Write and save medical report", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Send Photo", comment: ""), comment: "Default action"), style: .default,  handler: nil))
            
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Cancel", comment: ""), comment: "Default action"), style: .cancel,  handler: nil))
             
        }
        
              alert.view.layer.cornerRadius = 20
              alert.view.tintColor = .black
              present(alert, animated: true, completion: nil)
    }
    
    
    func internetPresense() {
           
           connectedRef = Database.database().reference(withPath: ".info/connected")
           
           connectHandle = connectedRef?.observe(.value) { (snapshot) in
               guard let connected = snapshot.value as? Bool, connected else   {
                   
                   self.online_typing.text = "Connecting"
                   self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                       self.goOnline()
                       if self.typing != true{
                           self.online_typing.text = "Connecting"
                       }
                       print("connecteding")
                       
                       
                   }
                            
                   self.connected = false
                   print("connected is: ",false)
                   self.send_btn.setTitle("no_internet", for: .normal)
                   self.send_btn.setTitleColor(.clear, for: .normal)
                            
                   
                   return
                             
                             
               }
               
               
               self.userOnlineStatus()
               self.timer?.invalidate()
                self.connected = true
                print("connected is: ",true)
                self.send_btn.setTitle("send", for: .normal)
                self.send_btn.setTitleColor(.clear, for: .normal)
               
               Database.database().goOnline()
               
               self.connected = connected
               
           }

           
           
       }
       
       func goOnline(){
           DispatchQueue.global(qos: .default).async {
               Database.database().goOffline()
               Database.database().goOnline()
           }
       }
    
    func userOnlineStatus() {
        
        onlineRef = Database.database().reference(withPath: "connections/user_\(otheruserid)/online")
        
        onlineHandle = onlineRef?.observe(.value) { (snapshot) in
            if snapshot.exists(){
                
                self.online = snapshot.value as! String
                
                if self.online == "true"{
                    self.online_typing.text = "Online"
                }else{
                    
                    self.online_typing.text = "Offline"
                    
                }
                
            }else{
                self.online_typing.text = "Offline"
            }
        }
        
    }
    
    func scrollToBottom() {
        if convoArray.count > 0 {
            let indexPath = NSIndexPath(row: self.convoArray.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
         
         if velocity.y < 0{
             view.endEditing(true)
         }
     }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "\n"{
            textView.text = ""
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
           
           DispatchQueue.global(qos: .default).async {
               
               if !self.userTypingExist{
                   if self.typing == false{
                    
                    
                    let ref = Database.database().reference().child("UserTyping").child(self.otheruserid).child("typing")
                    
                    
                    ref.setValue("true")
                       
                    self.userTypingExist = true
                       print("typing....")
                       self.typing = false
                       
                   }
               }else{
                   if self.typing == false{
                       
                       self.userTypingUpdate(typing: "true")
                       
                   }
               }
               
               self.typing = true
               
               
           }
           
           self.textTimer?.invalidate()
           
           self.textTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.textFieldStopEditing(sender:)), userInfo: nil, repeats: false)
           
       }
       
       @objc func textFieldStopEditing(sender: Timer) {

           typing = false
          print("typing stopped")
           userTypingUpdate(typing: "false")
           
       }
    
    func userTypingUpdate(typing: String) {
        DispatchQueue.global(qos: .default).async {
            
            let ref = Database.database().reference().child("UserTyping").child(self.otheruserid).child("typing")
            
            
            ref.setValue(typing)
            
            self.userTypingExist = true
            
        }
    }
     
    
        
        @objc func keyboardWillShow(sender: NSNotification) {
            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                 keyboardHeight = keyboardSize.height
                
                if tableView.contentSize.height > tableView.frame.size.height / 2 {
                    print(tableView_origin)
                    tableView_top.constant = 0 - keyboardHeight
                               
                    if keyboardHeight > 300{
                        send_constraint.constant = keyboardHeight - 30
                    }else{
                         send_constraint.constant = 5 + keyboardHeight
                    }
                    self.view.layoutIfNeeded()
                    print(keyboardHeight)
                }else{
                     
                     if keyboardHeight > 300{
                         send_constraint.constant = keyboardHeight - 30
                     }else{
                         send_constraint.constant = 5 + keyboardHeight
                     }
                    self.view.layoutIfNeeded()
                     print(keyboardHeight)
                }
             
             let height = self.tableView.frame.size.height
             let contentYoffset = self.tableView.contentOffset.y
             let distanceFromBottom = self.tableView.contentSize.height - contentYoffset
             if distanceFromBottom - 100 < height {
                 self.scrollToBottom()
             }
                             
               
            }
             
        }
        
        
        

        @objc func keyboardWillHide(sender: NSNotification) {
            if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                 keyboardHeight = keyboardSize.height
                 
                tableView_top.constant =  CGFloat(tableView_origin)
                send_constraint.constant = CGFloat(message_con_origin)
                self.view.layoutIfNeeded()
                 print(keyboardHeight)
                
             }
        }

     
     
     deinit {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
    
    
    func send_message() {
        
        let message_id = UUID.init().uuidString
        
        let databaseRef = Database.database().reference().child("Messages").child(userid).child(otheruserid).child(message_id)
        
        let otherDatabaseRef = Database.database().reference().child("Messages").child(otheruserid).child(userid).child(message_id)
        
        sent = 1
        
        
        
        
        let object = ["receiver":otheruserid,"sender":userid,"isSeen":false,"message":message_body.text!,"Timestamp":ServerValue.timestamp()] as [String : Any]
        
        let message = message_body.text
        message_body.text = ""
        
        
        
        databaseRef.setValue(object) { (error, reference) in
            otherDatabaseRef.setValue(object)
            
            otherDatabaseRef.keepSynced(true)
            databaseRef.keepSynced(true)
            
            
            
        }
        
        databaseRef.removeAllObservers()
        otherDatabaseRef.removeAllObservers()
        
        
    }

}
    
    

