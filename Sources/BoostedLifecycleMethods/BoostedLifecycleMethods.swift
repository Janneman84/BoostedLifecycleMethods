//
//  BoostedLifecycleMethods.swift
//
//  Created by Jan de Vries on 26/06/2024.
//

import UIKit

extension UIViewController {
    
    static let actuallySwizzleLifecycleMethods: Void = {
        method_exchangeImplementations(
            class_getInstanceMethod(UIViewController.self, #selector(viewDidLoad))!,
            class_getInstanceMethod(UIViewController.self, #selector(swizzledViewDidLoad))!
        )
        method_exchangeImplementations(
            class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear(_:)))!,
            class_getInstanceMethod(UIViewController.self, #selector(swizzleViewWillAppear(_:)))!
        )
        if #available(iOS 13, tvOS 13, *) {
            method_exchangeImplementations(
                class_getInstanceMethod(UIViewController.self, #selector(viewIsAppearing(_:)))!,
                class_getInstanceMethod(UIViewController.self, #selector(swizzleViewIsAppearing(_:)))!
            )
        }
        method_exchangeImplementations(
            class_getInstanceMethod(UIViewController.self, #selector(viewDidAppear(_:)))!,
            class_getInstanceMethod(UIViewController.self, #selector(swizzleViewDidAppear(_:)))!
        )
        method_exchangeImplementations(
            class_getInstanceMethod(UIViewController.self, #selector(viewWillDisappear(_:)))!,
            class_getInstanceMethod(UIViewController.self, #selector(swizzledViewWillDisappear(_:)))!
        )
        method_exchangeImplementations(
            class_getInstanceMethod(UIViewController.self, #selector(viewDidDisappear(_:)))!,
            class_getInstanceMethod(UIViewController.self, #selector(swizzleViewDidDisappear(_:)))!
        )
        Swift.print("Boosted lifecycle methods enabled. Add 'import BoostedLifecycleMethods' so you can override viewWillAppear🚀(), viewIsAppearing🚀(), viewDidAppear🚀(), viewWillDisappear🚀() and viewDidDisappear🚀() inside your ViewControllers.")
        Swift.print("You can also access UIViewController.hideKeyboardOnSheetDrag🚀, UIViewController.hideKeyboardOnTapOutside🚀, UIAlertController.cancelOnTapOutside🚀 and UIAlertController.closeOnTapOutsideButtonless🚀.")
    }()
    
    @objc func swizzledViewDidLoad() -> Void {
        swizzledViewDidLoad() //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
    }
    
    func loopProtect(_ callback: ()->Void) {
        let ao = ao
        assert(ao?.loopProtector != true, "Endless loop detected. Do not call regular (super) lifecycle method inside a 🚀 one.")
        ao?.loopProtector = true
        callback()
        ao?.loopProtector = false
    }
    
    @objc func swizzleViewWillAppear(_ animated: Bool) -> Void {
        swizzleViewWillAppear(animated) //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
        
        print("viewWillAppear \(self.title ?? self.description)")
        doViewWillAppear(animated)
        
        (self as? UIAlertController)?.addBackgroundTapRecognizer()
    }
    
    @objc func doViewWillAppear(_ animated: Bool) -> Void {
        let ao = ao
        guard !(ao?.abortingSwipeDown ?? false) else { return }
        loopProtect() {
            print("viewWillAppear🚀 \(self.title ?? self.description)")
            viewWillAppear🚀(animated)
        }
        if let presentedViewController = presentedViewController {
            ao?.presentedViewController = presentedViewController
        }
        else if let presentingViewController = presentingViewController, modalPresentationStyle != .fullScreen && rootParent == self {
            presentingViewController.allChildrenViewWillDisappear🚀(animated)
        }
        
        ao?.firstResponder?.becomeFirstResponder()
        ao?.firstResponder = nil
        
        // Bonus feature that fixes tintAdjustmentMode not adjusting when presentingViewController is not rootVC
        if let rootParent = presentingViewController?.rootParent,
           rootParent.presentingViewController != nil,
           modalPresentationStyle != .fullScreen {
            DispatchQueue.main.async() {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    rootParent.view.tintAdjustmentMode = .dimmed
                })
            }
        }
    }
    
    @available(iOS 13, tvOS 13, *)
    @objc func swizzleViewIsAppearing(_ animated: Bool) -> Void {
        swizzleViewIsAppearing(animated) //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
        print("viewIsAppearing \(self.title ?? self.description)")
        doViewIsAppearing(animated)
    }
    
    @available(iOS 13, tvOS 13, *)
    @objc func doViewIsAppearing(_ animated: Bool) -> Void {
        guard !(ao?.abortingSwipeDown ?? false) else { return }
        loopProtect() {
            print("viewIsAppearing🚀 \(self.title ?? self.description)")
            viewIsAppearing🚀(animated)
        }
    }
    
    @objc func swizzleViewDidAppear(_ animated: Bool) -> Void {
        swizzleViewDidAppear(animated) //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
        
        print("viewDidAppear \(self.title ?? self.description)")
        doViewDidAppear(animated)
    }
    
    @MainActor
    @objc func doViewDidAppear(_ animated: Bool) -> Void {
        loopProtect() {
            print("viewDidAppear🚀 \(self.title ?? self.description)")
            viewDidAppear🚀(animated)
        }
        
        let ao = ao
        
        ao?.setObservers()
        ao?.shadowObserver?.invalidate()
        ao?.abortingSwipeDown = false
        
        if ao?.presentedViewController != nil {
            ao?.presentedViewController = nil
        }
        else if let presentingViewController = presentingViewController, modalPresentationStyle != .fullScreen && rootParent == self {
            presentingViewController.allChildrenViewDidDisappear🚀(animated)
        }
       
        #if os(iOS)
        if presentedViewController == nil,
           rootParent == self,
           modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet,
           #available(iOS 13, tvOS 99, *),
           !ProcessInfo.processInfo.isMacCatalystApp,
           UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone,
           Self.hideKeyboardOnSheetDrag🚀,
           let ao,
           let dropShadow = presentationController?.containerView?.subviews.last(where: { type(of: $0).description().lowercased().contains("dropshadow") }),
           let layer = dropShadow.superview?.layer.sublayers?.last
        {
            ao.shadowFrame = layer.frame
            
            // Find pagesheet's UIDropShadowView and monitor its shadow for a cancel animation.
            ao.shadowObserver = layer.observe(\.position) { [weak self] _,_ in
                
//                print(dropShadow.frame)
//                print(layer.frame)
//                
//                if ao.shadowFrame.minX != dropShadow.frame.minX || ao.shadowFrame.width != dropShadow.frame.width {
//                    ao.shadowFrame = dropShadow.frame
//                    print("hatsikidee 1")
//                }
//                else if dropShadow.frame.minY <= ao.shadowFrame.minY {
//                    ao.firstResponder?.becomeFirstResponder()
//                    print("hatsikidee 2")
//                } else {
//                    ao.firstResponder?.resignFirstResponder()
//                }
                
                if ao.abortingSwipeDown {
                    ao.abortingSwipeDown = false
                    self?.doViewWillDisappear(true)
                }

                guard
                    self?.presentedViewController == nil
//                    , (layer.animationKeys() ?? []).isEmpty
                else {
                    return
                }
                DispatchQueue.main.async() {
                    for key in layer.animationKeys() ?? [] {
                        if let animation = layer.animation(forKey: key) as? CASpringAnimation,
                           let fromPoint = (animation.fromValue as? CGPoint)
                        {
                            if fromPoint.y.sign == .plus {
                                print("swipe down aborted \(self?.title ?? self?.description)")
                                self?.doViewWillAppear(true)
                                self?.doViewIsAppearing(true)
                                ao.abortingSwipeDown = true
                            } else {
                                print("swipe down continue \(self?.title ?? self?.description)")
                            }
                            break
                        }
                    }
                }
            }
        }
        #endif
    }
    
    @objc func swizzledViewWillDisappear(_ animated: Bool) -> Void {
        swizzledViewWillDisappear(animated) //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
        
        print("viewWillDisappear \(self.title ?? self.description)")
        doViewWillDisappear(animated)

        #if os(iOS)
        let ao = ao
        ao?.firstResponder = nil
        if presentedViewController == nil,
           rootParent == self,
           modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet,
           #available(iOS 13, tvOS 99, *),
           !ProcessInfo.processInfo.isMacCatalystApp,
           UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone,
           Self.hideKeyboardOnSheetDrag🚀
        {
            DispatchQueue.main.async() { [weak self] in
                DispatchQueue.main.async() { [weak self] in
                    if let firstResponder = self?.view.findFirstResponder() {
                        ao?.firstResponder = firstResponder
                        firstResponder.resignFirstResponder()
                    }
                }
            }
        }
        #endif
   }
    
    @objc func doViewWillDisappear(_ animated: Bool) -> Void {
        loopProtect() {
            print("viewWillDisappear🚀 \(self.title ?? self.description)")
            viewWillDisappear🚀(animated)
        }
        ao?.presentingViewController = nil //TODO necessary?
        if presentedViewController?.isBeingPresented != true, let presentingViewController = presentingViewController, modalPresentationStyle != .fullScreen && rootParent == self {
            presentingViewController.allChildrenViewWillAppear🚀(animated)
            ao?.presentingViewController = presentingViewController
        }
    }
    
    @objc func swizzleViewDidDisappear(_ animated: Bool) -> Void {
        swizzleViewDidDisappear(animated) //run original implementation
        if ao == nil {
            ao = AssociatedObject()
        }
        ao?.viewController = self
        
        print("viewDidDisappear \(self.title ?? self.description)")
        doViewDidDisappear(animated)
    }
    
    @objc func doViewDidDisappear(_ animated: Bool) -> Void {
        loopProtect() {
            print("viewDidDisappear🚀 \(self.title ?? self.description)")
            viewDidDisappear🚀(animated)
        }
        if let presentingViewController = ao?.presentingViewController {
            presentingViewController.allChildrenViewDidAppear🚀(animated)
        }
        ao?.shadowObserver?.invalidate()
    }

    var rootParent: UIViewController {
        parent?.rootParent ?? self
    }
    
    var ao: AssociatedObject? {
        set {
            objc_setAssociatedObject(self, &AssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedObject.key) as? AssociatedObject
        }
    }
    
    func allChildrenViewWillAppear🚀(_ animated: Bool) {
        print("viewWillAppear🚀 \(self.title ?? self.description)")
        viewWillAppear🚀(animated)
        if #available(iOS 13, tvOS 13, *) {
            print("viewIsAppearing🚀 \(self.title ?? self.description)")
            viewIsAppearing🚀(animated)
        }
        for child in children {
            if child.view.superview != nil {
                child.allChildrenViewWillAppear🚀(animated)
            }
        }
    }
    
    func allChildrenViewDidAppear🚀(_ animated: Bool) {
        print("viewDidAppear🚀 \(self.title ?? self.description)")
        viewDidAppear🚀(animated)
        for child in children {
            if child.view.superview != nil {
                child.allChildrenViewDidAppear🚀(animated)
            }
        }
    }
    
    func allChildrenViewWillDisappear🚀(_ animated: Bool) {
        print("viewWillDisappear🚀 \(self.title ?? self.description)")
        viewWillDisappear🚀(animated)
        for child in children {
            if child.view.superview != nil {
                child.allChildrenViewWillDisappear🚀(animated)
            }
        }
    }
    
    func allChildrenViewDidDisappear🚀(_ animated: Bool) {
        print("viewDidDisappear🚀 \(self.title ?? self.description)")
        viewDidDisappear🚀(animated)
        for child in children {
            if child.view.superview != nil {
                child.allChildrenViewDidDisappear🚀(animated)
            }
        }
    }
    

}
