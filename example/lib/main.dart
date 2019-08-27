import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_auth_wrapper/flutter_app_auth_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  var clientId = "511828570984-fuprh0cm7665emlne3rnf9pk34kkn86s.apps.googleusercontent.com";
  var clientSecret = "";

  String redirectURL = "com.google.codelabs.appauth:/oauth2callback";
  String authEndpoint = "https://accounts.google.com/o/oauth2/v2/auth";
  String tokenEndpoint = "https://www.googleapis.com/oauth2/v4/token";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: MaterialButton(
                  onPressed: () {
                    FlutterAppAuthWrapper.startAuth(
                      AuthConfig(
                        clientId: clientId,
                        clientSecret: clientSecret,
                        redirectUrl: redirectURL,
                        state: "login",
                        prompt: "consent",
                        endpoint: AuthEndpoint(
                            auth: authEndpoint, token: tokenEndpoint),
                        scopes: [
                          "profile"
                        ],
                      ),
                    );
                  },
                  child: Text('start OAuth'),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
