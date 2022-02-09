//
//  AuthViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    private let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    //to inform the signIn Status
    public var completionHandler : ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.frame = view.bounds
    }
    
}

extension AuthViewController : WKNavigationDelegate{
    
}
