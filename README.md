# flutter_app_auth_wrapper

The package wraps [App Auth](https://appauth.io), an OAuth 2.0 client for native
iOS and Android app development, into Flutter. You can use the package to
implements Oauth2 Authentication Code Flow in your Flutter app.

## Android

You need to do additional configuration in your AndroidManifest.xml to let your
app to accept the `net.openid.appauth.RedirectUriReceiverActivity`  and
`github.showang.flutterappauthwrapper.OAuthActivity` intent. For example:

```xml
<application>
    
    ...

    <activity
        android:name="net.openid.appauth.RedirectUriReceiverActivity"
        tools:node="replace">
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />

            <data
                android:host="ACCEPTED_HOST"
                android:scheme="YOUR_APP_SCHEME" />
        </intent-filter>


    </activity>

    <activity
        android:name="github.showang.flutterappauthwrapper.OAuthActivity"
        android:configChanges="orientation|screenSize"
        android:theme="@style/Theme.AppCompat.Translucent" />    
</application> 

```

Replace `ACCEPTED_HOST` and `YOUR_APP_SCHEME` depends on your app's definition.

## iOS

You need to add your own custom URL scheme to the Info.plist file.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleIdentifier</key>
        <string></string>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your_custom_url_scheme</string>
        </array>
    </dict>
</array>
```

You also need to let the app delegate to handle incoming open URL requests for
devices running iOS 9 or prior versions, if you want to support them.

```swift
override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

    if (SwiftFlutterAppAuthWrapperPlugin.authFlow?.resumeExternalUserAgentFlow(with: url) ?? false) {
        SwiftFlutterAppAuthWrapperPlugin.authFlow = nil
        return true
    }

    return false
}
```


### NOTES

For further information, please visit the page of [AppAuth Android](https://github.com/openid/AppAuth-Android).