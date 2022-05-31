// ignore_for_file: prefer_const_constructors

import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/home/home_scrren.dart';
import 'package:delivery_app/screens/signup/signup_screen.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  Services services = Services();
  final storage = FlutterSecureStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void logIn(context) async {
    try {
      var response = await services.logIn(email.text, password.text, "");
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                controller: email,
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
                  logIn(context);
                },
                text: "Login",
              ),
              SizedBox(
                height: defaultPadding,
              ),
              DefaultButton(
                press: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                text: "Create account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
