import 'package:chatting/sub_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yelp_fusion_client/yelp_fusion_client.dart';
import 'firebase_options.dart';

YelpFusion yelpapi;

Box box;
SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sharedPreferences = await SharedPreferences.getInstance();
  yelpapi = YelpFusion(
      apiKey:
          'EIpbinNZQAftydhz4isi_u-87kgcRcZLmrB4hpVEg-2_MNiqgwhVbMjs0aE1teyxpmMEvYMZaYgWKbe7qOpfQh9_YbN9RJPYRV24VK-ia_1tQcHQavtUV5IryoLEYnYx');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Chatting());

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const Chatting(),
  //   ),
  // );
}
