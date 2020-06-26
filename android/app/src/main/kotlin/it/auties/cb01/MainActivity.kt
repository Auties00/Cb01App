package it.auties.cb01

import android.os.Bundle
import io.flutter.plugins.videoplayer.VideoPlayerPlugin
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import creativecreatorormaybenot.wakelock.WakelockPlugin
import io.flutter.app.FlutterActivity
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
                override fun getAcceptedIssuers(): Array<X509Certificate?> {
                    return arrayOfNulls(0)
                }

                override fun checkClientTrusted(certs: Array<X509Certificate>, authType: String) {

                }

                override fun checkServerTrusted(certs: Array<X509Certificate>, authType: String) {

                }
            })

            val sc = SSLContext.getInstance("TLS")
            sc.init(null, trustAllCerts, SecureRandom())
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.socketFactory)
            HttpsURLConnection.setDefaultHostnameVerifier { _, _ -> true }
        } catch (exception: Exception) {
            exception.printStackTrace()
        }

        VideoPlayerPlugin.registerWith(this.registrarFor("io.flutter.plugins.videoplayer.VideoPlayerPlugin"))
        SharedPreferencesPlugin.registerWith(this.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        WakelockPlugin.registerWith(this.registrarFor("creativecreatorormaybenot.wakelock.WakelockPlugin"))
    }
}
