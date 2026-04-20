# BoostedLifecycleMethods for iOS

Adds `viewWillAppear🚀()`, `viewIsAppearing🚀()`, `viewDidAppear🚀()`, `viewWillDisappear🚀()` and `viewDidDisappear🚀()` to your UIViewControllers.

These act like the normal lifecycle methods, but has 2 main advantages:

1. When using pagesheets and formsheets.
2. When backgrounding and foregrounding the app.

## 1. Pagesheets/Formsheets

Normally when presenting a pagesheet or formsheet the presenting ViewController doesn't trigger `viewWillDisappear()` and `viewDidDisappear()`. Also when dismissing `viewWillAppear()`, `viewIsAppearing()`, `viewDidAppear()` won't get called. To fix this you can use the 🚀 versions of these methods which _will_ get called!

##### Bonus feature

When you drag down a pagesheet and you release it above the treshold the pagesheet snaps back up. This triggers `viewWillAppear()`, `viewIsAppearing()` and `viewDidAppear()`, but at the same time _after_ the animation has finished. However, `viewWillAppear🚀()` and `viewIsAppearing🚀()` will be triggered as soon as you let go and the animations _starts_.

## 2. Backgrounding/Foregrounding

Normally when backgrounding or foregrounding an app no lifecycle methods get called. However, 🚀 methods _will_ get called! When backgrounding the top most ViewController will trigger `viewWillDisappear🚀()` and `viewDidDisappear🚀()`. When foregrounding the top most ViewController will trigger `viewWillAppear🚀()`, `viewIsAppearing🚀()` and `viewDidAppear🚀()`.

## Installation

First install this package through SPM using the Github url `https://github.com/Janneman84/BoostedLifecycleMethods`. Make sure the library is linked to the target.

Then all you have to do is add `import BoostedLifecycleMethods` to your ViewController and the 🚀 lifecycle methods should become available.

### Warnings

- When overriding regular lifecycle methods make sure to call super inside them, else the 🚀 counterparts will not work.
- Do not call super to a regular lifecycle method inside a 🚀 one, this will trigger an assertion error.
- Calling super to a 🚀 method inside a 🚀 method is not necessary (but allowed).

