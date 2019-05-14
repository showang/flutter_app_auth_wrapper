package github.showang.flutterappauthwrapper

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.browser.customtabs.CustomTabsService
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.launch
import net.openid.appauth.browser.CustomTabManager
import android.content.pm.PackageManager
import android.R.attr.versionName


class FlutterAppAuthWrapperPlugin(private val activity: Activity) : MethodCallHandler, EventChannel.StreamHandler {

    companion object {

        var oauthEventSink: EventChannel.EventSink? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val flutterActivity = registrar.activity()
            val plugin = FlutterAppAuthWrapperPlugin(flutterActivity)
            val channel = MethodChannel(registrar.messenger(), "flutter_app_auth_wrapper")
            channel.setMethodCallHandler(plugin)

            EventChannel(registrar.messenger(), "oauth_completion_events").apply {
                setStreamHandler(plugin)
            }

        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startOAuth" -> startOAuth(call, result)
            else -> result.notImplemented()
        }

    }

    private fun startOAuth(call: MethodCall, result: Result) {
        activity.startActivity(Intent(activity, OAuthActivity::class.java).apply {
            putExtra(OAuthActivity.INPUT_STRING_JSON_AUTH_CONFIG, call.arguments.toString())
        })
        result.success(true)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        oauthEventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        oauthEventSink = null
    }
}