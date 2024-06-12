//
//  AlertPresenter.swift
//  Unsplasher
//
//  Created by Вадим Шишков on 12.06.2024.
//

import UIKit

final class AlertPresenter {
    
    static func show(in controller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )
        for button in model.buttons {
            let action = UIAlertAction(title: button.text, style: button.style) { _ in
                button.completion(())
            }
            alert.addAction(action)
            if button.isPreferredAction {
                alert.preferredAction = action
            }
        }
        if controller.presentedViewController == nil {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

struct AlertModel {
    let title = "Внимание"
    let message: String
    let buttons: [AlertButton<Void>] = [
        AlertButton(
            text: "Понятно",
            style: .cancel,
            completion: { _ in })
    ]
    let preferredStyle: UIAlertController.Style = .alert
}

struct AlertButton<T> {

    let text: String
    let style: UIAlertAction.Style
    let completion: (T) -> Void
    let isPreferredAction: Bool

    init(
        text: String,
        style: UIAlertAction.Style,
        completion: @escaping (T) -> Void,
        isPreferredAction: Bool = false
    ) {
        self.text = text
        self.style = style
        self.completion = completion
        self.isPreferredAction = isPreferredAction
    }
}
