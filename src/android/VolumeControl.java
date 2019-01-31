package com.commontime.plugin;

import android.content.Context;
import android.media.AudioManager;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;

public class VolumeControl extends CordovaPlugin {

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException
    {
        if ( action.equals("setDeviceVolume"))
        {
            double volume = args.getDouble(0);
            String id = args.getString(1);
            int streamId = getStreamIdForName(id);
            try {
                AudioManager audioManager = (AudioManager) cordova.getActivity().getSystemService(Context.AUDIO_SERVICE);
                int streamMaxVolume = audioManager.getStreamMaxVolume(streamId);
                double vol = (double)streamMaxVolume * volume;
                audioManager.setStreamVolume(streamId, (int)vol, 0);
                callbackContext.success();
            } catch (Exception e) {
                e.printStackTrace();
                callbackContext.error(e.getMessage());
            }
            return true;
        }
        else if ( action.equals("getDeviceVolume"))
        {
            String id = args.getString(0);
            int streamId = getStreamIdForName(id);
            int streamVolume = 0;
            int streamMaxVolume = 0;
            try {
                AudioManager audioManager = (AudioManager) cordova.getActivity().getSystemService(Context.AUDIO_SERVICE);
                streamVolume = audioManager.getStreamVolume(streamId);
                streamMaxVolume = audioManager.getStreamMaxVolume(streamId);
                double vol = (double) streamVolume / (double) streamMaxVolume;
                callbackContext.success(""+vol);
            } catch (Exception e) {
                e.printStackTrace();
                callbackContext.error(e.getMessage());
            }
            return true;
        }
        

        return true;
    }

    private int getStreamIdForName(String id) {
        int streamId = AudioManager.STREAM_MUSIC;
        if(id.equals("music")) {
            streamId = AudioManager.STREAM_MUSIC;
        } else if(id.equals("notification")) {
            streamId = AudioManager.STREAM_NOTIFICATION;
        } else if(id.equals("ring")) {
            streamId = AudioManager.STREAM_RING;
        } else if(id.equals("alarm")) {
            streamId = AudioManager.STREAM_ALARM;
        } else if(id.equals("voice")) {
            streamId = AudioManager.STREAM_VOICE_CALL;
        } else if(id.equals("system")) {
            streamId = AudioManager.STREAM_SYSTEM;
        } else if(id.equals("dtmf")) {
            streamId = AudioManager.STREAM_DTMF;
        }
        return streamId;
    }
}