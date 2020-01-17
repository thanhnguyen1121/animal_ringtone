package com.example.animalringtones.utils;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.provider.Settings;
import android.widget.Toast;


import com.example.animalringtones.R;
import com.example.animalringtones.utils.sharedpref.SharedPrefsUtils;
import com.example.ratedialog.RatingDialog;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class CallNative implements EventChannel.StreamHandler, RatingDialog.RatingDialogInterFace {
    private static final String CHANNEL = "CALL_FLUTTER_NATIVE";

    public static final String CALL_NATIVE_FLUTTER = "CALL_NATIVE_FLUTTER";
    private String TAG = CallNative.class.getSimpleName();
    Context context;
    MediaPlayer player = new MediaPlayer();
    int indexFilePlay = -1;
    boolean isFirst = true;
    int isSetSuccess = 0;

    @Override
    public void onDismiss() {

    }


    @Override
    public void onSubmit(float rating) {
        int count = SharedPrefsUtils.getInstance(context).getInt("rate");
        count++;
        SharedPrefsUtils.getInstance().putInt("rate", count);
        UtilsMenu.rateApp(context);
//        LogUtils.e("onSubmit" + rating);

    }


    @Override
    public void onRatingChanged(float rating) {
//        LogUtils.e("onRatingChanged" + rating);
    }

    public void showRateDialog() {
        int count = SharedPrefsUtils.getInstance(context).getInt("rate");

        if (count < 2) {
            RatingDialog ratingDialog = new RatingDialog(context);
            ratingDialog.setRatingDialogListener(this);
            ratingDialog.showDialog();
        }


    }


    public void callFlutterNative(FlutterActivity context) {
        this.context = context;

        new MethodChannel(context.getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("RATE")) {
                        this.showRateDialog();
                    }
                    if (call.method.equals("hasSettingsPermission")) {
                        boolean resultHasSettingsPermission = hasSettingsPermission();
                        result.success(resultHasSettingsPermission);
                    } else if (call.method.equals("requestSettingsPermission")) {
                        checkSystemWritePermission();
                        result.success(null);
                    } else if (call.method.equals("SET_CONTACT_RINGTONE")) {
                        try {
                            String fileName = call.argument("fileName");
                            int id = call.argument("resourceID");
                            setRingtone(id, fileName);
                            result.success("Thanh Cong");
                        } catch (Exception e) {
                            result.success("error");
                        }
                    } else if (call.method.equals("SET_NOTIFI_RINGTONE")) {

                        try {
                            String fileName = call.argument("fileName");
                            int id = call.argument("resourceID");
                            setNotification(id, fileName);
                            result.success("Thanh Cong SET_NOTIFI_RINGTONE");
                        } catch (Exception e) {
                            result.success("error" + e.toString());
                        }
                    } else if (call.method.equals("SET_ALARM_RINGTONE")) {
                        try {
                            System.out.println("id:" + call.argument("resourceID") + "__fileName:" + call.argument("fileName"));
                            String fileName = call.argument("fileName");
                            int id = call.argument("resourceID");
                            Uri fileUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + context.getPackageName() + "/" + id);
                            setAlarm(id, fileName);
                            result.success("Thanh cong!");
                        } catch (Exception e) {
                            result.success("error" + e.toString());
                        }
                    } else if (call.method.equals("PAUSE_RINGTONE")) {
                        System.out.println("Tam dung!");
                        player.pause();
                        result.success("pause");

                    } else if (call.method.equals("PLAY_RINGTONE")) {
                        int resourceID = call.argument("resourceID");
                        if (isFirst) {
                            isFirst = false;
                            indexFilePlay = call.argument("index");
                            startSound(resourceID);

                        } else {
                            int indexPlayNew = call.argument("index");
                            if (indexFilePlay != indexPlayNew) {
                                System.out.println("play moi");
                                indexFilePlay = indexPlayNew;
                                player.pause();
                                player = null;
                                startSound(resourceID);
                            } else {
                                System.out.println("Tiep tuc!");
                                player.start();
                            }
                        }
                    } else if (call.method.equals("GET_ALL_FILE_NAME_IN_RAW")) {
                        JSONArray arrayDataSent = new JSONArray();
                        Field[] fields = R.raw.class.getFields();
                        List<String> fileNameImage = getImageNameInAsset();
                        System.out.println("ksldjfsldkf:" + fileNameImage.toString());

                        for (int count = 0; count < fields.length; count++) {
                            JSONObject itemObject = new JSONObject();
                            try {
                                String name = fileNameImage.get(count);
                                int resourceID = fields[count].getInt(fields[count]);
                                itemObject.put("icon", "android/app/src/main/assets/images/" + name);
                                itemObject.put("resourceID", resourceID);
                                itemObject.put("isShowOption", false);
                                itemObject.put("isPlaying", false);
                                itemObject.put("fileName", fields[count].getName());
                                arrayDataSent.put(itemObject);

                            } catch (IllegalAccessException e) {
                                e.printStackTrace();
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                        result.success(arrayDataSent.toString());
                    } else {
                        result.notImplemented();
                    }
                });

    }


    int i;

    Timer myTimer;
    TimerTask doThis;
    Handler handler = new Handler(Looper.getMainLooper());

    public void callNativeFlutter(FlutterActivity context) {
        this.context = context;
        i = 0;
        new EventChannel(context.getFlutterView(), CALL_NATIVE_FLUTTER).setStreamHandler(this);
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {


        myTimer = new Timer();
        int delay = 0;   // delay for 30 sec.
        int period = 1000;  // repeat every 60 sec.

        doThis = new TimerTask() {
            public void run() {

                i++;
                handler.post(() -> {
                    eventSink.success(player.getCurrentPosition() + "");
                });


            }
        };

        myTimer.scheduleAtFixedRate(doThis, delay, period);

    }

    @Override
    public void onCancel(Object o) {
        myTimer.cancel();

    }


    private void startSound(int resourceID) {
//
//
        player = MediaPlayer.create(context, resourceID);
        player.start();
//        while (player.isPlaying()){
//            if(player.getCurrentPosition() == player.getDuration()){
//                System.out.println("ket thuc!");
//            }
//        }
    }


    private boolean checkSystemWritePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (Settings.System.canWrite(context))
                return true;
            else
                openAndroidPermissionsMenu();
        }
        return false;
    }

    private void openAndroidPermissionsMenu() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
            intent.setData(Uri.parse("package:" + context.getPackageName()));
            context.startActivity(intent);
        }
    }


    private boolean hasSettingsPermission() {
        boolean hasPermission = true;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            hasPermission = Settings.System.canWrite(context.getApplicationContext());
        }

        return hasPermission;
    }


    private void setRingtone(int resourceID, String title) {
        LinkedHashMap<String, Uri> listRingtone = RingtoneUtils.getRingTone(context.getApplicationContext());
        if (listRingtone.get(title) != null) {
            try {
                System.out.println("da co trong default");
                RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(),
                        RingtoneManager.TYPE_RINGTONE, listRingtone.get(title));

            } catch (Exception e) {
                System.out.println("loi:" + e.toString());
            }

        } else {

            try {
                String path = Environment.getExternalStorageDirectory() + "/Ringtones";
                File dir = new File(path);
                if (dir.mkdirs() || dir.isDirectory()) {
                    String str_song_name = title + ".mp3";
                    CopyRAWtoSDCard(resourceID, path + File.separator + str_song_name);
                    System.out.println("copy thanhf cong");
                    ContentValues contentValues = new ContentValues();
                    contentValues.put(MediaStore.MediaColumns.DATA, dir.getAbsolutePath() + "/" + str_song_name);
                    contentValues.put(MediaStore.MediaColumns.TITLE, title);
                    contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3");
                    contentValues.put(MediaStore.MediaColumns.SIZE, Long.valueOf(dir.length()));
                    contentValues.put(MediaStore.Audio.Media.ARTIST, "NONE");
                    contentValues.put(MediaStore.Audio.Media.IS_RINGTONE, true);
                    contentValues.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
                    contentValues.put(MediaStore.Audio.Media.IS_ALARM, false);
                    contentValues.put(MediaStore.Audio.Media.IS_MUSIC, false);
                    Uri uri1 = MediaStore.Audio.Media.getContentUriForPath(dir.getAbsolutePath());
                    Uri uri2 = context.getApplicationContext().getContentResolver().insert(uri1, contentValues);
//                    System.out.println("uri2: " + uri2.toString());
                    RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(),
                            RingtoneManager.TYPE_RINGTONE, uri2);
                    setRingtone(resourceID, title);
//
                }
                if(isSetSuccess <= 4){
                    isSetSuccess++;
                    setRingtone(resourceID, title);
                }else {
                    isSetSuccess = 0;
                }


            } catch (Exception e) {
                System.out.println("loi:" + e.toString());
            }
        }
    }

    private void setNotification(int resourceID, String title) {

        LinkedHashMap<String, Uri> listRingtone = RingtoneUtils.getNotificationTones(context.getApplicationContext());

        if (listRingtone.get(title) != null) {
            try {
                RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(), RingtoneManager.TYPE_NOTIFICATION, listRingtone.get(title));
            } catch (Throwable th) {
            }
        } else {

            try {
                String path = Environment.getExternalStorageDirectory() + "/Ringtones";
                File dir = new File(path);
                if (dir.mkdirs() || dir.isDirectory()) {
                    String str_song_name = title + ".mp3";
                    CopyRAWtoSDCard(resourceID, path + File.separator + str_song_name);
                    System.out.println("copy thanhf cong");
                    ContentValues contentValues = new ContentValues();
                    contentValues.put(MediaStore.MediaColumns.DATA, dir.getAbsolutePath() + "/" + str_song_name);
                    contentValues.put(MediaStore.MediaColumns.TITLE, title);
                    contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3");
                    contentValues.put(MediaStore.MediaColumns.SIZE, Long.valueOf(dir.length()));
                    contentValues.put(MediaStore.Audio.Media.ARTIST, "NONE");
                    contentValues.put(MediaStore.Audio.Media.IS_RINGTONE, false);
                    contentValues.put(MediaStore.Audio.Media.IS_NOTIFICATION, true);
                    contentValues.put(MediaStore.Audio.Media.IS_ALARM, false);
                    contentValues.put(MediaStore.Audio.Media.IS_MUSIC, false);
                    Uri uri1 = MediaStore.Audio.Media.getContentUriForPath(dir.getAbsolutePath());
                    Uri uri2 = context.getApplicationContext().getContentResolver().insert(uri1, contentValues);
                    System.out.println("uri2: " + uri2.toString());
                    RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(),
                            RingtoneManager.TYPE_NOTIFICATION, uri2);
                }
            } catch (Exception ex) {

            }
        }
    }

    private void setAlarm(int resourceID, String title) {

        LinkedHashMap<String, Uri> listRingtone = RingtoneUtils.getAlarmTones(context.getApplicationContext());

        if (listRingtone.get(title) != null) {
            System.out.println("co trong file default!");
            try {
                RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(),
                        RingtoneManager.TYPE_ALARM, listRingtone.get(title));
            } catch (Exception ex) {
                System.out.println("error:" + ex.toString());
            }
        } else {

            try {
                String path = Environment.getExternalStorageDirectory() + "/Ringtones";
                File dir = new File(path);
                if (dir.mkdirs() || dir.isDirectory()) {
                    String str_song_name = title + ".mp3";
                    CopyRAWtoSDCard(resourceID, path + File.separator + str_song_name);
                    System.out.println("copy thanhf cong");
                    ContentValues contentValues = new ContentValues();
                    contentValues.put(MediaStore.MediaColumns.DATA, dir.getAbsolutePath() + "/" + str_song_name);
                    contentValues.put(MediaStore.MediaColumns.TITLE, title);
                    contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3");
                    contentValues.put(MediaStore.MediaColumns.SIZE, Long.valueOf(dir.length()));
                    contentValues.put(MediaStore.Audio.Media.ARTIST, "NONE");
                    contentValues.put(MediaStore.Audio.Media.IS_RINGTONE, false);
                    contentValues.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
                    contentValues.put(MediaStore.Audio.Media.IS_ALARM, true);
                    contentValues.put(MediaStore.Audio.Media.IS_MUSIC, false);
                    Uri uri1 = MediaStore.Audio.Media.getContentUriForPath(dir.getAbsolutePath());
                    Uri uri2 = context.getApplicationContext().getContentResolver().insert(uri1, contentValues);
                    System.out.println("uri2: " + uri2.toString());
                    RingtoneManager.setActualDefaultRingtoneUri(context.getApplicationContext(),
                            RingtoneManager.TYPE_ALARM, uri2);
                }
            } catch (IOException e) {
                System.out.println("copy loi!");
                e.printStackTrace();
            }
        }
    }

    private void CopyRAWtoSDCard(int id, String path) throws IOException {
        InputStream in = context.getResources().openRawResource(id);
        FileOutputStream out = new FileOutputStream(path);
        byte[] buff = new byte[1024];
        int read = 0;
        try {
            while ((read = in.read(buff)) > 0) {
                out.write(buff, 0, read);
            }
        } finally {
            in.close();
            out.close();
        }
    }

    private List<String> getImageNameInAsset() {
        List<String> listFileName = new ArrayList<>();
        AssetManager aMan = context.getAssets();
        try {
            String[] filelist = aMan.list("images");
            for (int i = 0; i < filelist.length; i++) {
                if (filelist[i].contains("jpg")) {
                    listFileName.add(filelist[i]);
                }

            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return listFileName;
    }

}
