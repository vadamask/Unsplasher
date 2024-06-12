//
//  SplashViewController.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 11.06.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let tokenStorage = TokenStorage.shared
    private let authService: AuthServiceProtocol = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = tokenStorage.token {
            showMainScreen()
        } else {
            let authVC = AuthViewController()
            authVC.onGettingCode = { [weak self] code in
                guard let self else { return }
                
                self.authService.fetchToken(code) { result in
                    switch result {
                    case .success(_):
                        self.showMainScreen()
                    case .failure(let error):
                        AlertPresenter.show(in: self, model: AlertModel(message: error.localizedDescription))
                    }
                }
            }
            present(authVC, animated: true)
        }
    }
    
    private func showMainScreen() {
        let tabbarController = TabBarController()
        tabbarController.modalPresentationStyle = .fullScreen
        tabbarController.modalTransitionStyle = .crossDissolve
        present(tabbarController, animated: true)
    }
}
