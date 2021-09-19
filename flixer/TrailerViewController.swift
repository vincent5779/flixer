//
//  TrailerViewController.swift
//  flixer
//
//  Created by Hew, Vincent on 9/18/21.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var videoInfo: [String: Any]!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let baseUrl = "https://www.youtube.com/watch?v="
        let ytKey = videoInfo["key"] as! String
        let ytUrl = URL(string: baseUrl + "\(ytKey)")
        
        // Load website URL
        let myUrl = ytUrl
        let myReq = URLRequest(url: myUrl!)
        webView.load(myReq)
    }
    
    // Back button function to dismiss the view controller
    @IBAction func exitTrailer(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
