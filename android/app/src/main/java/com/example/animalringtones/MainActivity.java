package com.example.animalringtones;

import android.os.Bundle;

import com.example.animalringtones.utils.CallNative;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

    CallNative callNative;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        callNative = new CallNative();

        callNative.callFlutterNative(this);
        callNative.callNativeFlutter(this);


    }


}
