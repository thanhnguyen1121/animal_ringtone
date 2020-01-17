package com.example.animalringtones.utils.sharedpref;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;


import com.example.animalringtones.App;

import java.security.GeneralSecurityException;


/**
 * Created by nmtien92 on 4/24/2017.
 */

public class SharedPrefsUtils {

    Context activity;
    private SharedPreferences pref;
    private static SharedPrefsUtils utility;
    private SharedPreferences.Editor editor;
    private boolean autoCommit = true;

    public static SharedPrefsUtils getInstance(Context context) {
        if (utility == null) {
            utility = new SharedPrefsUtils(context.getApplicationContext());
        }
        return utility;
    }

    public static SharedPrefsUtils getInstance() {
        return getInstance(App.getContext());
    }

    private SharedPrefsUtils(Context activity, int mode) {
        this.autoCommit = true;
        this.activity = activity;
        pref = activity.getSharedPreferences(activity.getPackageName() + "_preferences", mode);
        editor = pref.edit();

    }

    private SharedPrefsUtils(Context activity) {
        this.autoCommit = true;
        this.activity = activity;
        pref = activity.getSharedPreferences(activity.getPackageName() + "_preferences", Context.MODE_PRIVATE);
        editor = pref.edit();
    }

    private SharedPrefsUtils(Activity activity, boolean autoCommit) {
        this.autoCommit = autoCommit;
        this.activity = activity;
        pref = PreferenceManager.getDefaultSharedPreferences(activity);
        editor = pref.edit();
    }

    public void removeValue(String key) {
        editor.remove(key);
        if (autoCommit) commit();
    }

    public void putString(String key, String value) {
        editor.putString(key, value);
        if (autoCommit) {
            commit();
        }
    }

    public String getString(String key) {
        String defaultValue = "";
        return pref.getString(key, defaultValue);
    }

    public void putInt(String key, int value) {
        editor.putInt(key, value);
        if (autoCommit) {
            commit();
        }
    }

    public int getInt(String key) {
        int defaultValue = 0;
        return pref.getInt(key, defaultValue);
    }

    public void putLong(String key, long value) {
        editor.putLong(key, value);
        if (autoCommit) {
            commit();
        }
    }

    public long getLong(String key) {
        long defaultValue = 0;
        return pref.getLong(key, defaultValue);
    }

    public void commit() {
        editor.commit();
    }

    public boolean getBoolean(String key, boolean defaultValue) {

        return pref.getBoolean(key, defaultValue);
    }

    public void putBoolean(String key, boolean value) {
        editor.putBoolean(key, value);
        if (autoCommit) {
            commit();
        }
    }

    public void putDouble(String key, double value) {
        editor.putString(key, String.valueOf(value));
        if (autoCommit) {
            commit();
        }
    }

    public double getDouble(String key) {
        double value = 0;
        String valueStr = pref.getString(key, "0");
        if (valueStr != null) {
            value = Double.valueOf(valueStr);
        }
        return value;
    }

    public boolean isAutoCommit() {
        return autoCommit;
    }

    public void setAutoCommit(boolean autoCommit) {
        this.autoCommit = autoCommit;
    }

    public boolean containsKey(String key) {
        return pref.contains(key);
    }

    public String getStringObfuscated(String key, Context context) {
        String defaultValue = "";
        String value = getString(key);
        if (value != null) {
            try {
                return SecurityUtils.deobfuscate(value, context);
            } catch (GeneralSecurityException e) {
            }
        }
        return defaultValue;
    }

    public void putStringObfuscated(String key, String value, Context context) {
        putString(key, SecurityUtils.obfuscateIfNotNull(value, context));
    }

    private SharedPrefsUtils() {
    }

    public String getString(String key, String defaultx) {
        String defaultValue = defaultx;
        return pref.getString(key, defaultValue);
    }
}
