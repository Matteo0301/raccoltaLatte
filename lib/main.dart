import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:raccoltalatte/auth.dart';
import 'package:raccoltalatte/collections/home.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/firebase_options.dart';
import 'package:raccoltalatte/login.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 30),
  ));

  if (!kIsWeb) {
    await remoteConfig.setDefaults(const {
      saveFileKey: true,
      uploadOnWifiKey: true,
      limitUsersKey: false,
    });

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      saveFile = remoteConfig.getBool(saveFileKey);
      uploadOnWifi = remoteConfig.getBool(uploadOnWifiKey);
      limitUsers = remoteConfig.getBool(limitUsersKey);
    });

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  if (!kIsWeb) {
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.wifi) && !FileList.sent) {
        FileList.sent = true;
        for (var elem in FileList.filenames) {
          uploadFile(elem.item1, elem.item2);
        }
        FileList.filenames.clear();
      }
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Raccolta latte',
      theme: MyTheme().theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Home(
                    title: 'Raccolta latte',
                    username: snapshot.data!.username,
                    admin: snapshot.data!.admin,
                  );
                }
                return const Login(title: 'Raccolta latte');
              },
            );
          }
          return const Login(title: 'Raccolta latte');
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
