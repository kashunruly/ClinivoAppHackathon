//
//  ConvoModel.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/29/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol ConvoDelegate: class {
    func downloadConvo(convos: [Convo])
}

class ConvoModel: NSObject {
    
    
    var convoDelegate: ConvoDelegate?
    
    
    var ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
     
    //var query: DatabaseQuery
         
    var convoArray = [Convo]()
    
    func removeConvoObservers() {
        if let _ = databaseHandle{
            ref.removeObserver(withHandle: databaseHandle!)
        }
    }
    
    
    func loadConvo(userid: String,otheruserid: String) {
        
       let ref2 = Database.database().reference().child("Messages").child(userid).child(otheruserid).queryOrdered(byChild: "Timestamp")
        
        
        ref2.observe(.value) { (snapshot) in
            ref2.keepSynced(true)
            var convoArray = [Convo]()
            
            for child in snapshot.children{
                
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any]{
                    
                    let dictkey = childSnapshot.key
                       // print("message:", dict["message"] as? String ?? "")
                    
                    let convo = Convo(message_id: dictkey, sender: dict["sender"] as? String ?? "", receiver: dict["receiver"] as? String ?? "", message: dict["message"] as? String ?? "", timeStamp: dict["timeStamp"] as? String ?? "", isSeen: dict["isSeen"] as? Bool ?? false)
                    
                 
                    convoArray.append(convo)
                    
                
                }
                
                
            }
            
            self.convoDelegate?.downloadConvo(convos: convoArray)
        }
        
    }

}

