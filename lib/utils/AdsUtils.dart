import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvp_flutter_tutorial/constance/Constances.dart';

class AdsUtils {
  static AdmobInterstitial interstitialAd;
  static var callBackADS;

  static addEventInterADS(callBack) {
    callBackADS = callBack;
    interstitialAd = AdmobInterstitial(
      adUnitId: Constances.ADMOD_INTER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        if (event == AdmobAdEvent.closed ||
            event == AdmobAdEvent.failedToLoad) {
          callBack();
        }
      },
    );
    interstitialAd.load();
  }

  static showInter() {
    var n = new Random().nextInt(2);
    if (n == 1) {
      showAdmosInter();
    } else {
      callBackADS();
      //  fbInterstitialAd();
    }
  }

  static fbInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: Constances.FB_INTER,
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd();
        }
        if (result == InterstitialAdResult.ERROR) {
          showAdmosInter();
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          callBackADS();
        }
      },
    );
  }

  static banner(type) {
    return type == 'fb'
        ? Container(
            alignment: Alignment.bottomCenter,
            child: FacebookBannerAd(
              placementId: Constances.ADOMD_BANNER,
              bannerSize: BannerSize.STANDARD,
              listener: (result, value) {
                switch (result) {
                  case BannerAdResult.ERROR:
                    print("Error: $value");
                    break;
                  case BannerAdResult.LOADED:
                    print("Loaded: $value");
                    break;
                  case BannerAdResult.CLICKED:
                    print("Clicked: $value");
                    break;
                  case BannerAdResult.LOGGING_IMPRESSION:
                    print("Logging Impression: $value");
                    break;
                }
              },
            ),
          )
        : AdmobBanner(
            adUnitId: Constances.ADOMD_BANNER,
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//            handleEvent(event, args, 'Banner');
            },
          );
  }

  static showAdmosInter() async {
    if (await interstitialAd.isLoaded)
      interstitialAd.show();
    else {
      callBackADS();
    }
  }
}
