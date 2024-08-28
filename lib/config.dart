import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

bool saveFile = true;
const saveFileKey = 'save_file';

bool appCheck = false;
const appCheckKey = 'app_check';
