# Flyshot SDK for iOS

## Prerequisites

Install the following:

* Xcode 10.2  or later
* iOS 10.0 or later

Make sure that your project meets the following requirements:

* Swift projects must use Swift 4.0 or later.
* ObjC projects must insure [ObjC projects configuration](#objc-projects-configuration).

# Integration

## Integration via Cocoapods

See [Cocoapods](https://cocoapods.org/) documentation

1. Navigate to your project folder in a terminal window.

2. Make sure you have the **CocoaPods 1.4.0 or later** installed  on your machine before installing the Flyshot
```sh
$ sudo gem install cocoapods
$ pod init
```
> This will create a file named Podfile in your project's root directory.

3. Add the following to header of your Podfile:
```sh
use_frameworks!
```
4.  Add the following to pods of your Podfile:
```sh
pod 'Flyshot'
```

5. Run the following command in your project root directory from a terminal window:
```sh
$ pod install
```

## Manually adding the SDK

1. Download following [Zip file](https://bitbucket.org/flyshot/ios-sdk/src/4.1.0/FlyshotSDK.xcframework.zip/)
2. In XCode, select your project in Project navigator
3. Finder, navigate to where you extracted the SDK
4. Drag **FlyshotSDK.xcframework** to the **Frameworks, Libraries and Embedded Content** section under the general settings tab of your application's target. 
5. Set the  **Add Files**  options as follows:
	-   **Destination**  - select  **Copy items if needed**
	-   **Added folders**  - select  **Create groups**
6. Set the `Embed` dropdown as `Embed and Sign`  for **FlyshotSDK.xcframework**.


## ObjC projects configuration

For ObjC projects setup please check that you defined **Swift Version** for your project target:

1. Open project's **Target**
2. Move to **Build Settings** tab
3. Press the + button
4.  Select **Add User-Defined Setting**
5.  Change new added row key to **SWIFT_VERSION**
6.  Set **SWIFT_VERSION** value equal or more then minimum support swift version.

# FEATURES

 Check [**Usage documentation**](https://flyshot.io/sdk/in-app-purchase)

