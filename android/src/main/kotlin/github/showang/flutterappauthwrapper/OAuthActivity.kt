package github.showang.flutterappauthwrapper

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.browser.customtabs.CustomTabsIntent
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import net.openid.appauth.*
import net.openid.appauth.browser.BrowserBlacklist
import kotlin.properties.ReadOnlyProperty
import kotlin.reflect.KProperty


class OAuthActivity : AppCompatActivity() {

    companion object {
        const val INPUT_STRING_JSON_AUTH_CONFIG = "11"

        private const val REQUEST_AUTH_CODE = 11
    }

    private val authConfigJson by stringExtra(INPUT_STRING_JSON_AUTH_CONFIG)

    private val eventSink get() = FlutterAppAuthWrapperPlugin.oauthEventSink

    private var authService: AuthorizationService? = null
    private val authConfig by lazy {
        try {
            Gson().fromJson(authConfigJson, AuthConfig::class.java)
        } catch (t: Throwable) {
            onError("Illegal argument error", "input json: $authConfigJson")
            null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val authConfig = authConfig ?: return
        val authRequest = with(AuthorizationRequest.Builder(
                AuthorizationServiceConfiguration(
                        Uri.parse(authConfig.endpoint.auth),
                        Uri.parse(authConfig.endpoint.token)
                ),
                authConfig.clientId,
                authConfig.type,
                Uri.parse(authConfig.redirectUrl)
        )) {
            setState(authConfig.state)
            setPrompt(authConfig.prompt)
            setScopes(authConfig.scopes)
            setAdditionalParameters(authConfig.customParameters)
            build()
        }

        authService = AuthorizationService(this, with(AppAuthConfiguration.Builder()) {
            setBrowserMatcher(BrowserBlacklist())
            build()
        })

        val authIntent: Intent? = try {
            authService?.getAuthorizationRequestIntent(authRequest, with(CustomTabsIntent.Builder()) {
                setToolbarColor(Color.parseColor(authConfig.color ?: "#2196F3"))
                setShowTitle(true)
                enableUrlBarHiding()
                build()
            })
        } catch (e: Throwable) {
            AuthorizationManagementActivity.createStartForResultIntent(this, authRequest, Intent(Intent.ACTION_VIEW).apply {
                data = authRequest.toUri()
            })
        }
        startActivityForResult(authIntent, REQUEST_AUTH_CODE)

    }

    override fun onDestroy() {
        super.onDestroy()
        authService?.dispose()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_AUTH_CODE -> {
                val sData = data ?: run {
                    onError("Auth callback null", null)
                    return
                }
                AuthorizationException.fromIntent(sData)?.run {
                    onError("Auth Exception", toJsonString())
                    return
                }
                val resp = AuthorizationResponse.fromIntent(sData) ?: run {
                    onError("Auth response null", null)
                    return
                }

                authService?.performTokenRequest(resp.createTokenExchangeRequest(),
                        ClientSecretBasic(authConfig?.clientSecret ?: "")) { response, ex ->
                    response?.apply {
                        eventSink?.success(Gson().toJson(mapOf(
                                "access_token" to accessToken,
                                "refresh_token" to refreshToken,
                                "expires_at" to accessTokenExpirationTime
                        )))
                        finish()
                    } ?: run { onError("Exchange Token Failed", ex) }
                }
            }
            else -> onError("Unknown callback error")
        }
    }

    private inline fun onError(message: String, details: Any? = "No details", callback: () -> Unit = {}) {
        eventSink?.error("OAuthError", message, details)
        finish()
        callback()
    }

}


fun stringExtra(key: String) =
        object : ReadOnlyProperty<Activity, String> {

            private var data: String? = null

            override fun getValue(thisRef: Activity, property: KProperty<*>): String {
                if (data == null) data = thisRef.intent.getStringExtra(key)
                return data ?: ""
            }
        }

data class AuthConfig(
        @SerializedName("endpoint") val endpoint: AuthEndpoint,
        @SerializedName("clientId") val clientId: String,
        @SerializedName("clientSecret") val clientSecret: String,
        @SerializedName("redirectUrl") val redirectUrl: String,
        @SerializedName("scopes") val scopes: List<String>,
        @SerializedName("state") val state: String,
        @SerializedName("prompt") val prompt: String,
        @SerializedName("type") val type: String,
        @SerializedName("customParameters") val customParameters: Map<String, String>,
        @SerializedName("color") val color: String?
)

data class AuthEndpoint(
        @SerializedName("auth") val auth: String,
        @SerializedName("token") val token: String
)