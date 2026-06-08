//
//  BoostedAlertController.swift
//  BoostedLifecycleMethods
//
//  Created by Jan de Vries on 06/06/2026.
//

import UIKit

public extension UIAlertController {
    
    /// Tap outside an alert to trigger the cancel button (if there is one).
    /// This setting applies to all alerts shown in your app. It is enabled by default.
    /// Also check `closeOnTapOutsideButtonless🚀`.
    static var cancelOnTapOutside🚀 = true
    
    /// Tap outside a buttonless alert to close it. This allows you to show alerts with no actions (buttons) while still being able to close them.
    /// This setting applies to all alerts shown in your app. It is enabled by default.
    /// Also check `cancelOnTapOutside🚀`.
    static var closeOnTapOutsideButtonless🚀 = true
}

extension UIAlertController {
    
    func addBackgroundTapRecognizer() {
        if Self.cancelOnTapOutside🚀, preferredStyle == .alert, view.superview?.gestureRecognizers == nil {
            view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alertBackgroundTapped)))
        }
    }
    
    @objc func alertBackgroundTapped() {
        guard !isBeingDismissed else { return }

        if Self.hideKeyboardOnTapOutside🚀 {
            for textField in self.textFields ?? [] {
                if textField.isFirstResponder {
                    textField.resignFirstResponder()
                    return;
                }
            }
        }
        if actions.isEmpty {
            if Self.closeOnTapOutsideButtonless🚀 {
                presentingViewController?.dismiss(animated: true)
            }
        }
        else {
            if Self.cancelOnTapOutside🚀 {
                for action in actions {
                    if action.style == .cancel {
                        if action.isEnabled {
                            presentingViewController?.dismiss(animated: true) {
                                self.triggerAction(action)
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    
    typealias alertActionHandler = @convention(block) (UIAlertAction) -> Void
    
    func triggerAction(_ action: UIAlertAction) {
        guard let block = action.value(forKey: "handler") else { return }
        let handler = unsafeBitCast(block as AnyObject, to: alertActionHandler.self)
        handler(action)
    }
}
