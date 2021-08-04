import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_call/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  bool _visible = true;
  bool _isVisible = true;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    PushManager().registerToken();
    PushManager().listenFirebaseMessaging();

    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    setState(() {
      widget._visible = !widget._visible;
    });

  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kopup',
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      Stack(
        children: [
          Root(),
          AnimatedOpacity(
            opacity: widget._visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            onEnd: (){
              if(!widget._visible)
                setState((){
                  widget._isVisible = false;
                });
            },
            child: Visibility(
              visible:  widget._isVisible ,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/logo.png',width: 100,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class PushManager {

  static final PushManager _manager = PushManager._internal();

  final _firebaseMessaging = FirebaseMessaging();

  factory PushManager() {
    return _manager;
  }

  PushManager._internal() {
    // 초기화 코드
  }

  void _requestIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void registerToken() {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    _firebaseMessaging.getToken().then((token) {
      print(token);
      // 장고 서버에 token알려주기
    });
  }

  void listenFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Triggered if a message is received whilst the app is in foreground
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        // Triggered if a message is received whilst the app is in background
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        // Triggered if a message is received if the app was terminated
        print('on launch $message');
      },
    );
  }
}