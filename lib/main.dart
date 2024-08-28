import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:raccoltalatte/auth.dart';
import 'package:raccoltalatte/collections/home.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/firebase_options.dart';
import 'package:raccoltalatte/login.dart';
import 'package:raccoltalatte/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  if (!kIsWeb) {
    await remoteConfig.setDefaults(const {
      saveFileKey: true,
    });

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      saveFile = remoteConfig.getBool(saveFileKey);
      appCheck = remoteConfig.getBool(appCheckKey);
    });

    // TODO AppCheck
    //await FirebaseAppCheck.instance.activate();

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
