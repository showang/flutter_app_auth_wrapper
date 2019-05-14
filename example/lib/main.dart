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

  String clientId = "Your client id";
  String clientSecret = "Your client secret";

  String redirectURL = "redirect url";
  String authEndpoint = "auth endpoint";
  String tokenEndpoint = "token endpoint";

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
                          "user_account_status",
                          "user_territory",
                          "user_profile"
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
