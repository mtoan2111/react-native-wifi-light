package com.reactnativewifilight;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Looper;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import android.os.Handler;

public class WifiLightModule extends ReactContextBaseJavaModule {
  private ReactApplicationContext context;
  private WifiManager _wifiManager;


  BroadcastReceiver _broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      context.unregisterReceiver(this);
      boolean success = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false);
      if (success) {
        scanSuccess();
      }
    }
  };

  @NonNull
  @Override
  public String getName() {
    return "Wifi";
  }

  public WifiLightModule(ReactApplicationContext context) {
    super(context);
    this._wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
    this.context = (ReactApplicationContext) getReactApplicationContext();
    Activity activity = this.context.getCurrentActivity();
    if (!this._wifiManager.isWifiEnabled()) {
      this.toast(this.context, "Scaning wifi....");
      this._wifiManager.setWifiEnabled(true);
    }
  }

  public void toast(final Context context, final String text) {
    Handler handler = new Handler(Looper.getMainLooper());
    handler.post(new Runnable() {
      public void run() {
        Toast.makeText(context, text, Toast.LENGTH_LONG).show();
      }
    });
  }

  @ReactMethod
  public void getWifiList() {
    scanSuccess();
  }

  @ReactMethod
  public void startScan() {
    getReactApplicationContext().getCurrentActivity().registerReceiver(this._broadcastReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
    this._wifiManager.startScan();
    Toast.makeText(this.context, "Scaning wifi....", Toast.LENGTH_SHORT).show();
  }

  @ReactMethod
  public void stopScan() {
    context.getApplicationContext().unregisterReceiver(this._broadcastReceiver);
  }

  private void scanSuccess() {
    List<ScanResult> aWifi = _wifiManager.getScanResults();
    WritableMap params = Arguments.createMap();
    JSONArray aWifiSSID = new JSONArray();
    Set<String> sWifi = new HashSet<String>();
    for (ScanResult ret : aWifi) {
      if (ret.SSID != "") {
        sWifi.add(ret.SSID);
      }
    }
    for (String w : sWifi) {
      JSONObject wifiObj = new JSONObject();
      try {
        wifiObj.put("SSID", w);
        aWifiSSID.put(wifiObj);
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    params.putString("data", aWifiSSID.toString());
    sendEvent("wifiScanResult", params);
  }

  private void sendEvent(String eventName, WritableMap params) {
    this.context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }
}
