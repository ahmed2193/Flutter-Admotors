import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutteradmotors/config/ps_theme_data.dart';
import 'package:flutteradmotors/constant/router.dart' as router;
import 'package:flutteradmotors/provider/common/ps_theme_provider.dart';
import 'package:flutteradmotors/provider/ps_provider_dependencies.dart';
import 'package:flutteradmotors/repository/ps_theme_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/language.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';

import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'db/common/ps_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  // if (Platform.isIOS) {
  //   _fcm.requestNotificationPermissions(const IosNotificationSettings());
  // }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', ''); //null);
    await prefs.setString('codeL', ''); //null);
  }

  try {
    // Firebase.initializeApp();
  await Firebase.initializeApp(
     name: 'flutter-ad-motors',
    options: Platform.isIOS
        ? const FirebaseOptions(
            appId: PsConfig.iosGoogleAppId,
            messagingSenderId: PsConfig.iosGcmSenderId,
            databaseURL: PsConfig.iosDatabaseUrl,
            projectId: PsConfig.iosProjectId,
            apiKey: PsConfig.iosApiKey)
        : const FirebaseOptions(
            appId: PsConfig.androidGoogleAppId,
            apiKey: PsConfig.androidApiKey,
            projectId: PsConfig.androidProjectId,
            messagingSenderId: PsConfig.androidGcmSenderId,
            databaseURL: PsConfig.androidDatabaseUrl,
          ),
  );
  } catch (e) {
    Utils.psPrint(e.toString());
  }


  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
//  NativeAdmob(adUnitID: Utils.getAdAppId());

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`
  // without this call.
  //
  // On iOS this is a no-op.
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  } else {
    InAppPurchaseIosPlatform.registerPlatform();
  }

  try {
    WidgetsFlutterBinding.ensureInitialized();
    Utils.cameras = await availableCameras();
  } on CameraException catch (e) {
    Utils.psPrint(e.toString());
  }

  MobileAds.instance.initialize();

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      path: 'assets/langs',
      saveLocale: true,
      startLocale: PsConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode!, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  late Completer<ThemeData>? themeDataCompleter;
  late PsSharedPreferences? psSharedPreferences;

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences!.futureShared.then((SharedPreferences sh) {
        psSharedPreferences!.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences!));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        themeDataCompleter!.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter!.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode!, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }


    String _authStatus = 'Unknown';
   Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
         final TrackingStatus status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');
        }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final String uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print('UUID: $uuid');
  }


  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    print('*** ${Utils.convertColorToString(PsColors.mainColor!)}');
    Utils.psPrint(EasyLocalization.of(context)!.locale.languageCode);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: ThemeManager(
            defaultBrightnessPreference: BrightnessPreference.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Panacea-Soft',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                // localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                //   EasyLocalization.of(context)!.delegate,
                //   DefaultCupertinoLocalizations.delegate
                // ],
                // supportedLocales:
                //     EasyLocalization.of(context)!.supportedLocales,
                // locale: EasyLocalization.of(context)!.locale,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              );
            }));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_authStatus', _authStatus));
  }
}
