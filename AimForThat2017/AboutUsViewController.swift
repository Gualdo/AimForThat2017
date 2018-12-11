//
//  AboutUsViewController.swift
//  AimForThat2017
//
//  Created by De La Cruz, Eduardo on 11/12/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            if let htmldata = try? Data(contentsOf: url) {
                let baseUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
                webView.load(htmldata, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: baseUrl)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func goBackButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
