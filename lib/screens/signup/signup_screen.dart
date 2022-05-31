// ignore_for_file: prefer_const_constructors

import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/home/home_scrren.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
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

  void signup(context) async {
    try {
      var response = await services.signup(
          name.text, email.text, phone.text, password.text, "");
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
