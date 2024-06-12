//
//  AuthViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import WebKit
import UIKit

final class AuthViewController: UIViewController {
    var onGettingCode: ((String) -> Void)?
    private lazy var webView = WKWebView(frame:  view.bounds)
    private let service: AuthServiceProtocol = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(service.authRequest!)
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if let url = navigationAction.request.url,
           let code = service.code(from: url) {
            onGettingCode?(code)
            dismiss(animated: true)
            return .cancel
        } else {
            return .allow
        }
    }
}
