import UIKit
import Flutter
import AppAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
	
  override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    print("app open url: :\(url)")
    if (SwiftFlutterAppAuthWrapperPlugin.authFlow?.resumeExternalUserAgentFlow(with: url) ?? false) {
	  SwiftFlutterAppAuthWrapperPlugin.authFlow = nil
      return true
    }

    return false
  }
	
}
