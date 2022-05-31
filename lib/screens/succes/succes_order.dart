import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccesOrder extends StatelessWidget {
  const SuccesOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Spacer(),
            Lottie.asset('assets/animations/success.json',
                width: getProportionateScreenWidth(300),
                height: getProportionateScreenHeight(300)),
            const Text(
              "Felicidades tu orden se ha creado exitosamente",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black38, fontSize: 22),
            ),
            const Spacer(),
            DefaultButton(
              press: () {
                Navigator.pop(context);
              },
              text: "Regresar",
            )
          ],
        ),
      ),
    ));
  }
}
