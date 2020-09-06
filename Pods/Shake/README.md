# Shake iOS SDK

[Shake](https://www.shakebugs.com/) is a dedicated bug reporting tool for mobile apps. Whenever a tester notices a bug, they can just shake their device and report it instantly, without ever leaving your app. Each bug report comes supplemented with various data points like location, storage, OS and others. These reports all arrive to your web Dashboard, where they can be organized with tags and found quickly using search. 

# Installation
## **Step 1**: Add Shake SDK to your Podfile
Not using CocoaPods yet? Follow their brief [installation guide](https://guides.cocoapods.org/using/getting-started.html#installation), then run `pod init` in the root of your project.  

Next, add Shake to your `Podfile`.

#### Objective-C
```objc
pod 'Shake'
```

#### Swift
```objc
use_frameworks! 
pod 'Shake'
```

Then, run the `pod install` command in your terminal.  

Since CocoaPods might not always download the latest version of an SDK when using `pod install`, it's recommended that you also run `pod update Shake` after the installation has completed, or whenever you'd like to update Shake.


## **Step 2:** Grab your API keys
Visit your Shake [dashboard](https://app.shakebugs.com/documentation/ios/installing) and grab the `Client ID` and `Secret` keys.

Then, right click on your `Info.plist > Open as > Source code` and paste the keys inside.

## **Step 3:** Initialize Shake SDK
#### Objective-C
In your `AppDelegate.m`:
```objc
#import "AppDelegate.h"
@import Shake;

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [SHKShake start];
  return YES;
}
@end
```

#### Swift
```swift
import UIKit
import Shake

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      Shake.start()
      return true
  }
}
```

## **Step 4:** Build and run
Select _Product > Run_ in the menu bar. This first run will automatically add your app to your [Shake Dashboard](https://app.shakebugs.com/) based on your app bundle ID.

&nbsp;
# Requirements
- iOS 10.0+

&nbsp;
# More
- Visit our official [website](https://www.shakebugs.com/).
