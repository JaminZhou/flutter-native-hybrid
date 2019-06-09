package com.jaminzhou.example;

import com.taobao.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class FlutterPage2 extends BoostFlutterActivity {

    @Override
    public void onRegisterPlugins(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }

    @Override
    public String getContainerName() {
        return "flutter_page2";
    }

    @Override
    public Map getContainerParams() {
        Map<String,String> params = new HashMap<>();
        return params;
    }
}
