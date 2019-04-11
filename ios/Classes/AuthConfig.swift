//
//  AuthConfig.swift
//  flutter_app_auth_wrapper
//
//  Created by William Wang on 2019/4/10.
//

import Foundation

struct AuthConfig {
	/// The client ID.
	let clientID: String
	/// The client secret.
	let clientSecret: String
	/// The redirect URL.
	let redirectURL: String
	/// The endpoints.
	let endpoint: Endpoint
	/// The authentication type.
	let type: String
	/// The state.
	let state: String
	/// The prompt.
	let prompt: String
	/// The scopes.
	let scopes: [String]?
	/// The custom parameters.
	let customParameters: [AnyHashable: Any]?
	
	/// Creates a new instance.
	
	/// - Parameter json: The json string to build the new object.
	init?(_ json: String) {
		guard let data = json.data(using: .utf8) else {
			return nil
		}
		let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
		guard let dict = object as? [AnyHashable: Any] else {
			return nil
		}
		clientID = dict["clientId"] as? String ?? ""
		clientSecret = dict["clientSecret"] as? String ?? ""
		redirectURL = dict["redirectUrl"] as? String ?? ""
		type = dict["type"] as? String ?? ""
		state = dict["state"] as? String ?? ""
		prompt = dict["prompt"] as? String ?? ""
		scopes = dict["scopes"] as? [String]
		customParameters = dict["customParameters"] as? [AnyHashable: Any]
		endpoint = Endpoint(auth: (dict["endpoint"] as? Dictionary)?["auth"] ?? "",
							token: (dict["endpoint"] as? Dictionary)?["token"] ?? "")
	}
}

/// The endpoints.
struct Endpoint {
	/// The endpoint for authentication.
	let auth: String
	/// The endpoint for fetching tokens.
	let token: String
	
	/// Creates a new instance.
	init(auth: String, token: String) {
		self.auth = auth
		self.token = token
	}
}
