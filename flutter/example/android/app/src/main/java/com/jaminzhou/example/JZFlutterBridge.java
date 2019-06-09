package com.jaminzhou.example;

import com.jaminzhou.flutter_bridge.FlutterBridge;

import java.util.Arrays;
import java.util.HashMap;
import io.flutter.plugin.common.MethodChannel;

public class JZFlutterBridge extends FlutterBridge {
    @Override
    public void getUserName(MethodChannel.Result result) {
        result.success("JaminZhou");
    }

    @Override
    public void getAppVersion(MethodChannel.Result result) {
        result.success("7.0.1");
    }

    @Override
    public void request(String path, String method, HashMap<String, Object> parameter, MethodChannel.Result result) {
        String log = String.format("path= %s, method= %s", path, method, Arrays.toString(parameter.entrySet().toArray()));
        System.out.println(log);
        // result.success(map);
        result.error("10000", "this is error message", null);
    }
}
