package com.reactnativeadididfa

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class AdidIdfaModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNAdidIdfa"
    }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    fun getAdId(promise: Promise) {
      Thread {
        try {
          val adInfo = AdvertisingIdClient.getAdvertisingIdInfo(reactContext)
          val adId = adInfo.id
          promise.resolve(adId)
        } catch (e: Exception) {
          Log.e("AdIdModule", "Failed to get ADID", e)
          promise.reject("ADID_ERROR", e)
        }
      }.start()
    }


}
