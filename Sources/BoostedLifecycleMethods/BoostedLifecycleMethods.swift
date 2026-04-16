//
//  BoostedLifecycleMethods.swift
//
//  Created by Jan de Vries on 26/06/2024.
//

import UIKit

public extension UIViewController {
    
    ///Works like regular *viewWillAppear()*, but this one also gets called when closing a non-fullscreen modal (e.g. pagesheet) and when app returns to foreground.
    ///
    ///There is no need to call its super but feel free to do so.
    ///
    ///- Warning: Do **NOT** call *viewWillAppear()* or *super.viewWillAppear()* inside this method, this will cause an endless loop.
    @objc open func viewWillAppear🚀(_ animated: Bool) {}
    
    ///Works like regular *viewIsAppearing()*, but this one also gets called when closing a non-fullscreen modal (e.g. pagesheet) and when app returns to foreground.
    ///
    ///There is no need to call its super but feel free to do so.
    ///
    ///- Warning: Do **NOT** call  *viewIsAppearing()* or *super.viewIsAppearing()* inside this method, this will cause an endless loop.
    @available(iOS 13, tvOS 13, *)
    @objc open func viewIsAppearing🚀(_ animated: Bool) {}
    
    ///Works like regular *viewDidAppear()*, but this one also gets called when closing a non-fullscreen modal (e.g. pagesheet) and when app returns to foreground.
    ///
    ///There is no need to call its super but feel free to do so.
    ///
    ///- Warning: Do **NOT** call *viewDidAppear()* or *super.viewDidAppear()* inside this method, this will cause an endless loop.
    @objc open func viewDidAppear🚀(_ animated: Bool) {}
    
    ///Works like regular *viewWillDisappear()*, but this one also gets called when opening a non-fullscreen modal (e.g. pagesheet) and when app goes to background.
    ///
    ///There is no need to call its super but feel free to do so.
    ///
    ///- Warning: Do **NOT** call *viewWillDisappear()* or *super.viewWillDisappear()* inside this method, this will cause an endless loop.
    @objc open func viewWillDisappear🚀(_ animated: Bool) {}
    
    ///Works like regular *viewDidDisappear()*, but this one also gets called when opening a non-fullscreen modal (e.g. pagesheet) and when app goes to background.
    ///
    ///There is no need to call its super but feel free to do so.
    ///
    ///- Warning: Do **NOT** call *viewDidDisappear)* or *super.viewDidDisappear* inside this method, this will cause an endless loop.
    @objc open func viewDidDisappear🚀(_ animated: Bool) {}
    
    /// This is called automatically on startup to initialize the boosted lifecycle methods. There is no need to call this manually yourself (but won't hurt either).
    /// When debug is enabled extra information will be printed to the console.
    @objc static func _boostLifecycleMethods(debug: Bool = false) {
        debuggy = debug
        actuallySwizzleLifecycleMethods //this makes sure it can only swizzle once
    }
}

fileprivate var debuggy = false

fileprivate extension UIViewController {
    
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
    }()
    
    @objc func swizzledViewDidLoad() -> Void {
        swizzledViewDidLoad() //run original implementation
        ao = AssociatedObject()
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
        doViewWillAppear(animated)
    }
    
    @objc func doViewWillAppear(_ animated: Bool) -> Void {
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
    }
    
    @available(iOS 13, tvOS 13, *)
    @objc func swizzleViewIsAppearing(_ animated: Bool) -> Void {
        swizzleViewIsAppearing(animated) //run original implementation
        doViewIsAppearing(animated)
    }
    
    @available(iOS 13, tvOS 13, *)
    @objc func doViewIsAppearing(_ animated: Bool) -> Void {
        guard !(ao?.abortingSwipeDown ?? false) else { return }
        loopProtect() {
            print("viewIsAppearing🚀 \(self.title ?? self.description)")
            viewIsAppearing🚀(animated)
        }
        
        // Bonus feature that fixes tintAdjustmentMode not adjusting when presentingViewController is not rootVC
        if let rootParent = presentingViewController?.rootParent,
           rootParent.presentingViewController != nil,
           modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet {
            DispatchQueue.main.async() {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    rootParent.view.tintAdjustmentMode = .dimmed
                })
            }
        }
    }
    
    @objc func swizzleViewDidAppear(_ animated: Bool) -> Void {
        swizzleViewDidAppear(animated) //run original implementation
        doViewDidAppear(animated)
    }
    
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
       
        if presentedViewController == nil,
           rootParent == self,
           modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet,
           #available(iOS 13, tvOS 99, *),
           !ProcessInfo.processInfo.isMacCatalystApp,
           let dropShadow = presentationController?.containerView?.subviews.last(where: { type(of: $0).description().lowercased().contains("dropshadow") }),
           let layer = dropShadow.superview?.layer.sublayers?.last
        {
            
            // Find pagesheet's UIDropShadowView and monitor its shadow for a cancel animation.
            ao?.shadowObserver = layer.observe(\.position) { [weak self] _,_ in

                if (ao?.abortingSwipeDown ?? false) {
                    ao?.abortingSwipeDown = false
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
                                ao?.abortingSwipeDown = true
                            } else {
                                print("swipe down continue \(self?.title ?? self?.description)")
                            }
                            break
                        }
                    }
                }
            }
        }
    }
    
    @objc func swizzledViewWillDisappear(_ animated: Bool) -> Void {
        swizzledViewWillDisappear(animated) //run original implementation
        doViewWillDisappear(animated)
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
    
    class AssociatedObject {
        
        static var key = malloc(1)!
        
        weak var viewController: UIViewController?
        
        var loopProtector = false
        
        var abortingSwipeDown = false
        
        var shadowObserver: NSKeyValueObservation?
        
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
        
        deinit {
            NotificationCenter.default.removeObserver(self) //just in case
            shadowObserver?.invalidate() //just in case
        }
    }
}

//formatter for print()'s timestamp (below), is lazily instantiated so never gets called in release builds:
fileprivate var printTimeDateFormatter : DateFormatter = {
    let tdf = DateFormatter()
    tdf.dateFormat = "HH:mm:ss.SSS"
    return tdf
}()


//redefinition of print() so it only prints to console in debug builds, and adds a timestamp which is often handy:
func print(_ items: Any..., separator: String = "", terminator: String = "\n") {
    #if DEBUG
    if debuggy {
        var idx = items.startIndex
        let endIdx = items.endIndex
        repeat {
            Swift.print("\(printTimeDateFormatter.string(from: Date())) \(items[idx])", separator: separator, terminator: idx+1 == endIdx ? terminator : separator)
            idx += 1
        }
        while idx < endIdx
    }
    #endif
}
