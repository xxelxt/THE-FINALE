import 'package:dingtea/infrastructure/services/tr_keys.dart';

import 'infrastructure/services/enums.dart';

abstract class AppConstants {
  AppConstants._();

  /// api urls
  static const String baseUrl = 'https://api.dingtea.top/';
  static const String drawingBaseUrl = 'https://api.openrouteservice.org';
  static const String googleApiKey = 'AIzaSyALwzJXGf8fBFdzHF0TT4pqp7np6foXEYw';
  static const String adminPageUrl = 'https://admin.dingtea.top';
  static const String webUrl = 'https://dingtea.top';
  static const String firebaseWebKey =
      'AIzaSyDRcvv-yOgUFOy4E13vs3pATsuRA5NDqHw';
  static const String uriPrefix = 'https://dtea.page.link';
  static const String routingKey =
      '5b3ce3597851110001cf6248131dbb4b4dfa4b209d2d95386d3ea746';
  static const String androidPackageName = 'com.xxelxt.dtea';
  static const String iosPackageName = 'com.xxelxt.dtea.customer';
  static const bool isDemo = true;
  static const bool isPhoneFirebase = true;
  static const int scheduleInterval = 60;
  static const SignUpType signUpType = SignUpType.email;

  /// PayFast
  static const String passphrase = 'jt7NOE43FZPn';
  static const String merchantId = '10000100';
  static const String merchantKey = '46f0cd694581a';

  static const String demoUserLogin = '';
  static const String demoUserPassword = '';

  /// locales
  static const String localeCodeEn = 'en';
  static const String chatGpt =
      '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';

  /// auth phone fields
  static const bool isNumberLengthAlwaysSame = true;
  static const String countryCodeISO = 'VN';
  static const bool showFlag = true;
  static const bool showArrowIcon = true;

  /// location
  static const double demoLatitude = 21.008669;
  static const double demoLongitude = 105.828007;
  static const double pinLoadingMin = 0.116666667;
  static const double pinLoadingMax = 0.611111111;

  static const Duration timeRefresh = Duration(seconds: 30);

  static const List infoImage = [
    "assets/images/save.png",
    "assets/images/delivery.png",
    "assets/images/fast.png",
    "assets/images/set.png",
  ];

  static const List infoTitle = [
    TrKeys.saveTime,
    TrKeys.deliveryRestriction,
    TrKeys.fast,
    TrKeys.set,
  ];

  static const payLater = [
    "progress",
    "canceled",
    "rejected",
  ];
  static const genderList = [
    "male",
    "female",
  ];
}
