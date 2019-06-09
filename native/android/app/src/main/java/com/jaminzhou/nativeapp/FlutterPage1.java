package com.jaminzhou.nativeapp;

import com.taobao.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class FlutterPage1 extends BoostFlutterActivity {

    @Override
    public void onRegisterPlugins(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }

    @Override
    public String getContainerName() {
        return "flutter_page1";
    }

    @Override
    public Map getContainerParams() {
        Map<String,String> params = new HashMap<>();
        return params;
    }
}
