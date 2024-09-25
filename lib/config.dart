import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

bool saveFile = true;
const saveFileKey = 'save_file';

bool uploadOnWifi = true;
const uploadOnWifiKey = 'upload_on_wifi';

bool limitUsers = false;
const limitUsersKey = 'limit_users';
