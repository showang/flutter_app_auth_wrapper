package github.showang.flutterappauthwrapper

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class FlutterAppAuthWrapperPlugin(private val activity: Activity) : MethodCallHandler, EventChannel.StreamHandler {

    companion object {

        private const val CHANNEL_METHOD = "flutter_app_auth_wrapper"
        private const val CHANNEL_EVENT = "oauth_completion_events"

        const val METHOD_START_OAUTH = "startOAuth"

        var oauthEventSink: EventChannel.EventSink? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val methodChannel = MethodChannel(registrar.messenger(), CHANNEL_METHOD)
            val eventChannel = EventChannel(registrar.messenger(), CHANNEL_EVENT)
            FlutterAppAuthWrapperPlugin(registrar.activity())
                    .apply(methodChannel::setMethodCallHandler)
                    .also(eventChannel::setStreamHandler)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_START_OAUTH -> startOAuth(call, result)
            else -> result.notImplemented()
        }
    }

    private fun startOAuth(call: MethodCall, result: Result) {
        Intent(activity.applicationContext, OAuthActivity::class.java).apply {
            putExtra(OAuthActivity.INPUT_STRING_JSON_AUTH_CONFIG, call.arguments.toString())
        }.run(activity::startActivity)
        result.success(true)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        oauthEventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        oauthEventSink = null
    }
}