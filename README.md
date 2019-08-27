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

Support AndroidX.
Add following properties into `gradle.properties` to enable AndroidX support.
```properties
android.enableJetifier=true
android.useAndroidX=true
```

When a custom scheme is used, AppAuth can be easily configured to capture all redirects using this custom scheme through a manifest placeholder:
```groovy
android.defaultConfig.manifestPlaceholders = [
  'appAuthRedirectScheme': 'com.example.app'
]
```

Alternatively, the redirect URI can be directly configured by adding an intent-filter for AppAuth's RedirectUriReceiverActivity to your AndroidManifest.xml:
```xml
<activity
        android:name="net.openid.appauth.RedirectUriReceiverActivity"
        tools:node="replace">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="com.example.app"/>
    </intent-filter>
</activity>
```

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
