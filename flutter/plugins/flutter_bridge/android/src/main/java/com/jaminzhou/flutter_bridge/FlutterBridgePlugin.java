package com.jaminzhou.flutter_bridge;

import java.lang.reflect.Method;
import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterBridgePlugin implements MethodCallHandler {

  private static FlutterBridgePlugin instance = new FlutterBridgePlugin();

  private FlutterBridgePlugin(){}

  public static FlutterBridgePlugin getInstance(){
    return instance;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_bridge");
    channel.setMethodCallHandler(FlutterBridgePlugin.getInstance());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (this.bridge == null) {
      result.notImplemented();
      return;
    }

    String methodString = call.method;
    Class cls =  this.bridge.getClass();
    try {
      ArrayList arguments = (ArrayList)call.arguments;
      if (arguments == null) {
        arguments = new ArrayList();
      }
      Class[] parameterTypes = new Class[arguments.size()+1];
      for (int i =0;i < arguments.size(); i++) {
        parameterTypes[i] = arguments.get(i).getClass();
      }

      Object[] args = new Object[arguments.size()+1];
      for (Object argument: arguments) {
        args[arguments.indexOf(argument)] = argument;
      }

      //添加入参 result
      parameterTypes[arguments.size()] = Result.class;
      args[arguments.size()] = result;

      Method method = cls.getMethod(methodString, parameterTypes);
      method.invoke(this.bridge, args);
    }
    catch (Exception e){
      result.notImplemented();
    }
  }

  private FlutterBridge bridge;

  public static void registerFlutterBridge(FlutterBridge bridge) {
    FlutterBridgePlugin.getInstance().bridge = bridge;
  }
}
