package com.example.animalringtones;

import android.content.Context;

import com.crashlytics.android.Crashlytics;

import io.fabric.sdk.android.Fabric;
import io.flutter.app.FlutterApplication;

public class App extends FlutterApplication {
    static Context context;

    public static Context getContext() {
        return context;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Fabric.with(this, new Crashlytics());
//        AdsExchange.init(this, "5df4dc1910892d04fcaeabd0");
        this.context = this;
    }
}
