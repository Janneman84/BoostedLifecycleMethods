//
//  BoostedLifeCycleMethodsPublic.swift
//  BoostedLifecycleMethods
//
//  Created by Jan de Vries on 06/06/2026.
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
    @objc static func _boostLifecycleMethods🚀(debug: Bool = false) {
        debuggy = debug
        actuallySwizzleLifecycleMethods //this makes sure it can only swizzle once
    }
    
    /// On iPhone, dragging down a pagesheet/formsheet will hide the keyboard. Releasing the sheet above the closing treshold will show it again.
    /// This setting applies to all pagesheet/formsheet shown in your app. It is enabled by default.
    /// Also check `hideKeyboardOnTapOutside🚀`.
    static var hideKeyboardOnSheetDrag🚀: Bool = true
    
    /// Hide the keyboard by tapping outside a pagesheet/formsheet (iPad) or outside an alert.
    /// This setting applies to all pagesheet/formsheet and alerts shown in your app. It is enabled by default.
    /// Also check `hideKeyboardOnSheetDrag🚀`.
    static var hideKeyboardOnTapOutside🚀: Bool = true
}
