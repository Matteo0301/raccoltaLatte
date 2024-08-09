import 'package:firebase_remote_config/firebase_remote_config.dart';

bool saveFile = false;
final remoteConfig = FirebaseRemoteConfig.instance;
const saveFileKey = 'save_file';
