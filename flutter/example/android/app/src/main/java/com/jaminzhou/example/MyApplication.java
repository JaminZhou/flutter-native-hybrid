package com.jaminzhou.example;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import com.jaminzhou.flutter_bridge.FlutterBridgePlugin;
import com.taobao.idlefish.flutterboost.Debuger;
import com.taobao.idlefish.flutterboost.FlutterBoostPlugin;
import com.taobao.idlefish.flutterboost.interfaces.IPlatform;

import java.util.Map;

import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterBridgePlugin.registerFlutterBridge(new JZFlutterBridge());

        FlutterBoostPlugin.init(new IPlatform() {
            @Override
            public Application getApplication() {
                return MyApplication.this;
            }

            @Override
            public Activity getMainActivity() {
                return MainActivity.sRef.get();
            }

            @Override
            public boolean isDebug() {
                return false;
            }

            @Override
            public boolean startActivity(Context context, String url, Map params, int requestCode) {
                Debuger.log("startActivity url="+url);
                return false;
            }

            @Override
            public Map getSettings() {
                return null;
            }
        });
    }
}
