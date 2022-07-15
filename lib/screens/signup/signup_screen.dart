// ignore_for_file: prefer_const_constructors

import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/home/home_screen.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Services services = Services();
  final storage = FlutterSecureStorage();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    // TODO: implement initState
    registerNotification();
    super.initState();
  }

  void signup(context) async {
    try {
      String? token = await _messaging.getToken();
      var response = await services.signup(
          name.text, email.text, phone.text, password.text, token!);
      var jwt = response['token'];
      if (jwt != null) {
        await storage.write(key: "jwt", value: jwt);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      }
    } catch (err) {
      print(err);
      showSnackBar(context, "Error");
    }
  }

   void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Delivery",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    hintText: "Name",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: const Icon(Boxicons.bx_user)),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: const Icon(Boxicons.bx_envelope)),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Phone",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: const Icon(Boxicons.bx_phone)),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Contrasena",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: const Icon(Boxicons.bx_hide)),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              DefaultButton(
                press: () {
                  signup(context);
                },
                text: "Sign up",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
