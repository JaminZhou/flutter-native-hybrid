package com.jaminzhou.flutter_bridge;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel.Result;

public abstract class FlutterBridge {
    /** User Name*/
    public abstract void getUserName(Result result);

    /** App Version*/
    public abstract void getAppVersion(Result result);

    /** request*/
    public  abstract void request(String path, String method, HashMap<String, Object> parameter, Result result);
}
