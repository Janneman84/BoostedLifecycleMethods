//
//  UIView+findFirstResponder.swift
//  BoostedLifecycleMethods
//
//  Created by Jan de Vries on 06/06/2026.
//

import UIKit

extension UIView {
    func iterateSubviews(maxLevel:UInt = UInt.max, level: UInt = 0, onSubview: (UIView, UInt)->(Bool)) {
        if onSubview(self, level) {
            let level = level + 1
            if level <= maxLevel {
                for subview in subviews {
                    subview.iterateSubviews(maxLevel: maxLevel, level: level, onSubview: onSubview)
                }
            }
        }
    }
    
    func findFirstResponder() -> UIView? {
        var firstResponder: UIView? = nil
        iterateSubviews() { subview, level in
            if subview.isFirstResponder {
                firstResponder = subview
                return false
            }
            return true
        }
        return firstResponder
    }
}
