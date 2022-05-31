import 'dart:convert';

import 'package:delivery_app/provider/app_provider.dart';
import 'package:delivery_app/screens/home/home_scrren.dart';
import 'package:delivery_app/screens/login/login_screen.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.yellow,
        ),
        home: const RootScreen(),
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final storage = FlutterSecureStorage();

  Future<String> get jwtOrEmpty async {
    String? jwt = "";
    jwt = await storage.read(key: "jwt");

    if (jwt == null) return "";

    if (jwt != null && jwt.isNotEmpty) {
      var token = jwt.split(".");
      var payload =
          json.decode(ascii.decode(base64.decode(base64.normalize(token[1]))));
      if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
          .isAfter(DateTime.now())) {
      } else {
        await storage.delete(key: "jwt");
      }
    }

    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data != "") {
            return const HomeScreen();
          } else {
            return const LogInScreen();
          }
        });
  }
}
