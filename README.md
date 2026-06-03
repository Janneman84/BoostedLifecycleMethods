[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJanneman84%2FBoostedLifecycleMethods%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Janneman84/BoostedLifecycleMethods)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJanneman84%2FBoostedLifecycleMethods%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Janneman84/BoostedLifecycleMethods)[![](https://shields.io/badge/UIKit-white?logo=swift&?style=social)](https://swiftpackageindex.com/Janneman84/AnimationSpeedBooster)
[![Swift Package Manager compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

# BoostedLifecycleMethods for iOS

Adds `viewWillAppear🚀()`, `viewIsAppearing🚀()`, `viewDidAppear🚀()`, `viewWillDisappear🚀()` and `viewDidDisappear🚀()` to your UIViewControllers.

These act like the normal lifecycle methods, but has 2 main advantages:

1. When using pagesheets and formsheets.
2. When backgrounding and foregrounding the app.

## 1. Pagesheets/Formsheets

Normally when presenting a pagesheet or formsheet the presenting ViewController doesn't trigger `viewWillDisappear()` and `viewDidDisappear()`. Also when dismissing `viewWillAppear()`, `viewIsAppearing()`, `viewDidAppear()` won't get called. To fix this you can use the 🚀 versions of these methods which _will_ get called!

## 2. Backgrounding/Foregrounding

Normally when backgrounding or foregrounding an app no lifecycle methods get called. However, 🚀 methods _will_ get called! When backgrounding the top most ViewController will trigger `viewWillDisappear🚀()` and `viewDidDisappear🚀()`. When foregrounding the top most ViewController will trigger `viewWillAppear🚀()`, `viewIsAppearing🚀()` and `viewDidAppear🚀()`.

## 3. Bonus feature

When dragging down a pagesheet the keyboard will automatically go away. If you cancel the drag it comes back immediately (iPhone only).

<img width="320" height="569" alt="ezgif com-video-to-gif-converter" src="https://github.com/user-attachments/assets/02af1d01-ae3f-4143-b56b-795601155a2b" />

This all works automatically, no need to code anything. This works in SwiftUI too!

## 4. Subtle detail

When you drag down a pagesheet and you release it above the treshold the pagesheet snaps back up. This triggers `viewWillAppear()`, `viewIsAppearing()` and `viewDidAppear()`, but at the same time _after_ the animation has finished. However, `viewWillAppear🚀()` and `viewIsAppearing🚀()` will be triggered as soon as the cancel animations _starts_.

## 5. tintAdjustmentMode fix

This package also fixes some inconsistencies regarding tintAdjustmentMode. For example, when showing an alert the buttons on the presenting VC will now always turn gray (instead of only in some cases).

## Installation

First install this package through SPM using the Github url `https://github.com/Janneman84/BoostedLifecycleMethods`. Make sure the library is linked to the target.

Then all you have to do is add `import BoostedLifecycleMethods` to your ViewController and the 🚀 lifecycle methods should become available.

### Warnings

- When overriding regular lifecycle methods make sure to call super inside them, else the 🚀 counterparts will not work.
- Do not call super to a regular lifecycle method inside a 🚀 one, this will trigger an assertion error.
- Calling super to a 🚀 method inside a 🚀 method is not necessary (but allowed).

