[![pub package](https://img.shields.io/pub/v/flutter_app_auth_wrapper.svg)](https://pub.dev/packages/flutter_app_auth_wrapper)
# flutter_app_auth_wrapper

The package wraps [App Auth](https://appauth.io), an OAuth 2.0 client for native
iOS and Android app development, into Flutter. You can use the package to
implements Oauth2 Authentication Code Flow in your Flutter app.

## Usage

Start oauth flow

```dart
FlutterAppAuthWrapper.startAuth(
                      AuthConfig(
                        clientId: clientId,
                        clientSecret: clientSecret,
                        redirectUrl: redirectURL,
                        state: "login",
                        prompt: "consent",
                        endpoint: 
                        AuthEndpoint(auth: authEndpoint, token: tokenEndpoint),
                        scopes: [
                          "user_account_status",
                          "user_territory",
                          "user_profile"
                        ],
                      ),
                    );
```

Listen result event by `FlutterAppAuthWrapper.eventStream()`.

```dart
StreamBuilder(
                initialData: "init state",
                stream: FlutterAppAuthWrapper.eventStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    var error = snapshot.error as PlatformException;
                    return Text("[Error] ${error.message}: ${error.details}");
                  } else {
                    return Text(snapshot.data.toString());
                  }
                },
              )
```

## Setting Up

### Android

Only support AndroidX.

Add following properties into `gradle.properties` to enable AndroidX support.
```properties
android.enableJetifier=true
android.useAndroidX=true
```


You need to do additional configuration in your AndroidManifest.xml to let your
app to accept the `net.openid.appauth.RedirectUriReceiverActivity`  and
`github.showang.flutterappauthwrapper.OAuthActivity` intent. For example:

```xml
<application
    xmlns:tools="http://schemas.android.com/tools">
    
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

Add translucent theme style to `res/values`.

```xml
<style name="Theme.AppCompat.Translucent" parent="@style/Theme.AppCompat.NoActionBar">
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowBackground">@android:color/transparent</item>
    <item name="android:colorBackgroundCacheHint">@null</item>
    <item name="android:windowIsTranslucent">true</item>
    <item name="android:windowAnimationStyle">@android:style/Animation</item>
    <item name="android:statusBarColor">@android:color/transparent</item>
</style>
```

Replace `ACCEPTED_HOST` and `YOUR_APP_SCHEME` depends on your app's definition.

For further information, please visit the page of [AppAuth Android](https://github.com/openid/AppAuth-Android).

### iOS

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

For further information, please visit the page of [AppAuth iOS](https://github.com/openid/AppAuth-iOS).

# Use this package as a library
## 1. Depend on it
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_app_auth_wrapper: {last_version}
```

## 2. Install it
You can install packages from the command line:

with pub:

```console
$ pub get
```
with Flutter:

```console
$ flutter packages get
```
Alternatively, your editor might support pub get or flutter packages get. Check the docs for your editor to learn more.

## 3. Import it
Now in your Dart code, you can use:

```dart
import 'package:flutter_app_auth_wrapper/flutter_app_auth_wrapper.dart';
```
