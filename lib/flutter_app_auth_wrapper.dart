import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FlutterAppAuthWrapper {
  static const MethodChannel _channel =
      const MethodChannel('flutter_app_auth_wrapper');
  static const EventChannel _authEventChannel =
      const EventChannel('oauth_completion_events');

  static Future<bool> startAuth(AuthConfig config) async {
    return await _channel.invokeMethod('startOAuth', config.buildJson());
  }

  static Stream<dynamic> eventStream() {
    return _authEventChannel.receiveBroadcastStream();
  }
}

enum AuthType { CODE, TOKEN, ID_TOKEN }

class AuthEndpoint {
  String auth;
  String token;

  AuthEndpoint({
    @required this.auth,
    @required this.token,
  });
}

class AuthConfig {
  AuthEndpoint endpoint;

  AuthType type;

  List<String> scopes;

  String clientId;
  String clientSecret;
  String redirectUrl;

  String state;
  String prompt;

  String color;

  Map<String, String> customParameters;

  AuthConfig(
      {@required this.clientId,
      @required this.clientSecret,
      @required this.redirectUrl,
      @required this.endpoint,
      this.type = AuthType.CODE,
      this.state = "login",
      this.prompt = "",
      this.scopes = const <String>[],
      this.customParameters = const {},
      this.color});

  String buildJson() {
    return json.encode({
      'clientId': clientId,
      'clientSecret': clientSecret,
      'redirectUrl': redirectUrl,
      'endpoint': {'auth': endpoint.auth, 'token': endpoint.token},
      'type': _typeString(type),
      'state': state,
      'prompt': prompt,
      'scopes': scopes,
      'customParameters': customParameters,
      'color': color,
    });
  }

  String _typeString(AuthType type) {
    switch (type) {
      case AuthType.CODE:
        return 'code';
      case AuthType.TOKEN:
        return 'token';
      case AuthType.ID_TOKEN:
        return 'id_token';
      default:
        return '';
    }
  }
}
