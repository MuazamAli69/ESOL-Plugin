package io.fuse.esol

//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugins.GeneratedPluginRegistrant
//
//class MainActivity : FlutterFragmentActivity() {
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//
//    }
//}
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
                if (call.method == "helloFromNativeCode") {

                    print("message");

                   // result.success('Hello Data of the Code');
                } else {
                      print("Error From Native");
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                }
        
            }
    }
}
