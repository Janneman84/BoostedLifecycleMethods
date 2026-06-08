//
//  AssociatedObject.swift
//  BoostedLifecycleMethods
//
//  Created by Jan de Vries on 06/06/2026.
//

import UIKit

class AssociatedObject: NSObject, UIAdaptivePresentationControllerDelegate {
    
    nonisolated(unsafe) static var key = malloc(1)!
    
    weak var viewController: UIViewController? { didSet {
        if oldValue != viewController,
           let pvc = viewController?.presentingViewController?.presentedViewController, // When root vc this returns nil, aka full screen.
           pvc.modalPresentationStyle == .pageSheet || pvc.modalPresentationStyle == .formSheet
           // Somehow setting the delegate to parent if full screen causes memory leak, no point then anyway so just skip.
        {
            // This delegate triggers presentationControllerShouldDismiss() below
            pvc.presentationController?.delegate = self
        }
    }}
    
    var loopProtector = false
    
    var abortingSwipeDown = false
    
    var shadowObserver: NSKeyValueObservation?
    
    var shadowFrame: CGRect = .zero

    weak var firstResponder: UIView?
    
    var hasSetObservers = false
    func setObservers() {
        guard !hasSetObservers else { return }
        hasSetObservers = true
        DispatchQueue.main.async() { [self] in
            if #available(iOS 13, tvOS 13, *) {
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),  name: UIScene.willEnterForegroundNotification,          object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground),   name: UIScene.didActivateNotification,                  object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground),  name: UIScene.willDeactivateNotification,               object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground),   name: UIScene.didEnterBackgroundNotification,           object: nil)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),  name: UIApplication.willEnterForegroundNotification,    object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground),   name: UIApplication.didBecomeActiveNotification,        object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground),  name: UIApplication.willResignActiveNotification,       object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground),   name: UIApplication.didEnterBackgroundNotification,     object: nil)
            }
        }
    }
    
    weak var presentingViewController: UIViewController?
    weak var presentedViewController: UIViewController?
    
    var alreadyEnteredBackground = false //prevents double calling on mac
    var prevWillEnterBackground = false
    
    @objc private func willEnterBackground() {
        if #available(iOS 13, tvOS 13, *), ProcessInfo.processInfo.isMacCatalystApp && viewController?.view.window?.windowScene?.activationState != .foregroundActive { return }
        print("willEnterBackground 🚀")
        alreadyEnteredBackground = false
        prevWillEnterBackground = true
        if let viewController = viewController, viewController.presentedViewController == nil, viewController.parent == nil {
            viewController.allChildrenViewWillDisappear🚀(false)
        }
        
        // just in case
        if viewController == nil {
            shadowObserver?.invalidate()
        }
    }
    
    @objc private func didEnterBackground() {
        print("didEnterBackground 🚀")
        guard !alreadyEnteredBackground else { return }
        alreadyEnteredBackground = true
        prevWillEnterBackground = false
        if let viewController = viewController, viewController.presentedViewController == nil, viewController.parent == nil {
            viewController.allChildrenViewDidDisappear🚀(false)
        }
    }
    
    @objc private func willEnterForeground() {
        if #available(iOS 13, tvOS 13, *), ProcessInfo.processInfo.isMacCatalystApp && UIApplication.shared.applicationState != .active { return }
        print("willEnterForeground 🚀")
        prevWillEnterBackground = false
        if let viewController = viewController, viewController.presentedViewController == nil, viewController.parent == nil {
            viewController.allChildrenViewWillAppear🚀(false)
        }
    }
    
    @objc private func didEnterForeground() {
        if #available(iOS 13, tvOS 13, *), ProcessInfo.processInfo.isMacCatalystApp && UIApplication.shared.applicationState != .active { return }
        print("didEnterForeground 🚀")
        //fix for when resizing iPad split view only triggers active notifications and not background notifications
        if prevWillEnterBackground {
            didEnterBackground()
            willEnterForeground()
        }
        prevWillEnterBackground = false
        if let viewController = viewController, viewController.presentedViewController == nil, viewController.parent == nil {
            viewController.allChildrenViewDidAppear🚀(false)
        }
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        if #available(iOS 13.0, *),
           !ProcessInfo.processInfo.isMacCatalystApp,
           UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {

            // Tapping outside (on iPad) will just close keyboard first and VC on second tap
            if presentationController.presentedView?.gestureRecognizers?.first?.state == .possible {
                if let firstResponder = viewController?.view.findFirstResponder() {
                    firstResponder.resignFirstResponder()
                    return false
                }
            }
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //just in case
        shadowObserver?.invalidate() //just in case
    }
}
