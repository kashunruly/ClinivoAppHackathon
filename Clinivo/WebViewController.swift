//
//  WebViewController.swift
//  FimiLinkApp
//
//  Created by Kashlon Palmer on 4/7/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class WebViewController: UIViewController,GADBannerViewDelegate,WKUIDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var goBack_con: UIView!
    @IBOutlet weak var goBack_btn: UIButton!
    
    @IBOutlet weak var goForward_con: UIView!
    @IBOutlet weak var goForward_btn: UIButton!
    
    @IBOutlet weak var refresh_con: UIView!
    @IBOutlet weak var refresh_btn: UIButton!
    
    @IBOutlet weak var stopLoad_con: UIView!
    @IBOutlet weak var stopLoad_btn: UIButton!
    
    var url = ""
    
    let shapeLayer = CAShapeLayer()
    let trackLayer =  CAShapeLayer()
    
    
    var timer: Timer?
    
    let button = UIButton.init(type: .custom)
    
    @IBOutlet weak var close_con: UIView!
    @IBOutlet weak var close_web: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: "arrow.left.square.fill") {
                button.setImage(image, for: .normal)
                button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
            }
        } else {
            button.setTitle("BACK", for: .normal)
        }
        button.backgroundColor = UIColor(red: 91/255, green: 28/255, blue: 70/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(red: 121/255, green: 206/255, blue: 244/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1
        button.applyShadow()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        hideKeyBoardWhenTappedAround()
        
        goBack_con.layer.cornerRadius = 20
        goBack_con.applyShadow()
        
        close_con.layer.cornerRadius = 10
        close_con.applyShadow()
        
        close_web.layer.cornerRadius = 10
        
        goForward_con.layer.cornerRadius = 20
        goForward_con.applyShadow()
        
        refresh_con.layer.cornerRadius = 20
        refresh_con.applyShadow()
        
        stopLoad_con.layer.cornerRadius = 20
        stopLoad_con.applyShadow()

        
               
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
        
        let urlRequest = URLRequest(url: URL(string: self.url)!)
        
        webView.load(urlRequest)
        
        webView.allowsBackForwardNavigationGestures = true
        
        webView.allowsLinkPreview = true
        
        
        
        
        if webView.isLoading{
            bufferSpinner()
        }
        
            timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { (Timer) in
        
                    
                    
                    
                    if self.webView.isLoading{
                        print("dhu")
                        self.shapeLayer.isHidden = false
                        self.trackLayer.isHidden = false
                        self.shapeLayer.strokeEnd = CGFloat(self.webView.estimatedProgress)
                    }
        
                }
        
        
        
    
    }
    @IBAction func close_btn_tapped(_ sender: Any) {
        close_con.zoomIn()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        timer?.fire()
        shapeLayer.isHidden = false
        trackLayer.isHidden = false
        shapeLayer.strokeEnd = CGFloat(webView.estimatedProgress)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        shapeLayer.isHidden = true
        trackLayer.isHidden = true
        shapeLayer.strokeEnd = 0
        timer?.invalidate()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        timer?.fire()
        shapeLayer.isHidden = false
        trackLayer.isHidden = false
        shapeLayer.strokeEnd = CGFloat(webView.estimatedProgress)
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        shapeLayer.isHidden = true
        trackLayer.isHidden = true
        shapeLayer.strokeEnd = 0
        timer?.invalidate()
    }
    
    @IBAction func stopLoad_btn_tapped(_ sender: Any) {
        stopLoad_con.zoomIn()
        webView.stopLoading()
        shapeLayer.isHidden = true
        trackLayer.isHidden = true
        shapeLayer.strokeEnd = 0
        timer?.invalidate()
    }
    
    @IBAction func refresh_btn_tapped(_ sender: Any) {
        refresh_con.zoomIn()
        shapeLayer.strokeEnd = 0
        webView.stopLoading()
        let urlRequest = URLRequest(url: URL(string: self.url)!)
        webView.load(urlRequest)
        
        
    }
    
    @IBAction func goBack_btn_tapped(_ sender: Any) {
        goBack_con.zoomIn()
        if webView.canGoBack {
            shapeLayer.strokeEnd = 0
            webView.goBack()
        }
        
    }
    @IBAction func goForward_btn_tapped(_ sender: Any) {
        goForward_con.zoomIn()
        if webView.canGoForward {
            shapeLayer.strokeEnd = 0
            webView.goForward()
        }
        
    }
    
    @IBAction func back_btn_tapped(_ sender: UIButton) {
        sender.zoomIn()
        webView.stopLoading()
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func bufferSpinner()  {
       
        shapeLayer.isHidden = false
       
       
        
        let aquaInspireColor = UIColor(red:67/255, green:206/255, blue:162/255, alpha:1.0)
        
        // create track layer
        
        
         //UIBezierPath(arcCenter: top, radius: 0, startAngle: 0, endAngle: webView.frame.width , clockwise: true)
        
        let circularPath = UIBezierPath(rect: CGRect(x: 0, y: 5, width: self.view.bounds.width, height: 5))
        
        
        
        
        trackLayer.lineCap = CAShapeLayerLineCap.round
        //trackLayer.lineDashPhase = 10
        
        
        //trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.strokeEnd = 1
        
        ///
        
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //shapeLayer.lineDashPhase = 10
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = aquaInspireColor.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        
        //anim
        
        let basicAnimation = CABasicAnimation()
        
        basicAnimation.toValue = 0
        
        basicAnimation.duration = 2
        
        basicAnimation.isRemovedOnCompletion = true
        
        //basicAnimation.repeatCount = 1
        
        shapeLayer.add(basicAnimation, forKey: "anim")
        
        webView.layer.addSublayer(trackLayer)
        webView.layer.addSublayer(shapeLayer)
        
        
        
    }
    
    
    
    
    
}
