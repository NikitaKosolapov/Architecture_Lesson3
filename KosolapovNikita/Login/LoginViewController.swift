//
//  WKWebLoginViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 08.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit
import WebKit
import Alamofire


// Define ViewController
class LoginViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            var urlComponents = URLComponents()
            urlComponents.scheme = "http"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "7450792"),
                                        URLQueryItem(name: "display", value: "mobile"),
                                        URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                        URLQueryItem(name: "scope", value: "262150, wall, friends"),
                                        URLQueryItem(name: "response_type", value: "token"),
                                        URLQueryItem(name: "v", value: "token")]
            
            let request = URLRequest(url: urlComponents.url!)
            webView.load(request)
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)) // declare UITapGestureRecognizer
        
        view.addGestureRecognizer(tap) // add UITapGestureRecognizer to the view
        
        // MARK: keyboard notificaton
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: dismissKeyboard
    @objc func dismissKeyboard() { // func is triggered when tap on the screen
        view.endEditing(true)
    }
    
    // MARK: keyboardWasShown
    @objc func keyboardWasShown(notification: Notification) { // func is triggered when keyboard will appear
        let userInfo = (notification as NSNotification).userInfo as! [String: Any]
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        scrollBottomConstraint.constant = frame.height
    }
    
    // MARK: keyboardWillBeHidden
    @objc func keyboardWillBeHidden(notification: Notification) { // func is triggered when keyboard will disappear
        scrollBottomConstraint.constant = 0
    }
}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let parameters = fragment
            .components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = parameters["access_token"], let userId = parameters["user_id"] else { return } // check availability of received parameters
        
        Session.shared.token = token // save received token to the Session singleton
        Session.shared.userId = Int(userId)! // save received userId the the Session singleton
        
        print("Current token: \(Session.shared.token)")
        print("Current userID: \(Session.shared.userId)\n")
        
        decisionHandler(.cancel) // navigation ended
        
        performSegue(withIdentifier: "Login", sender: nil) // go to the next ViewContoller
    }
}
