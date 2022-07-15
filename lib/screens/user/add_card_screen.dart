import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  Services services = Services();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController exp = TextEditingController();
  String type = "VISA";

  void addNewCard() async {
    if (name.text.isNotEmpty && number.text.isNotEmpty && exp.text.isNotEmpty) {
      final dynamic data = {
        "newCard": {
          "name": name.text,
          "number": number.text,
          "exp": exp.text,
          "cardType": type,
        }
      };
      print(data);
      var response = await services.updateMe(data);
      print(response);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Spacer(),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                  hintText: "Nombre",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: Icon(Boxicons.bx_user)),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            TextField(
              controller: number,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Numero",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: Icon(Boxicons.bx_credit_card)),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                DropdownButton(
                    value: type,
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(child: Text("Visa"), value: "VISA"),
                      DropdownMenuItem(
                          child: Text("Mastercard"), value: "MASTER"),
                      DropdownMenuItem(child: Text("Venmo"), value: "VENMO"),
                      DropdownMenuItem(child: Text("Paypal"), value: "PAYPAL"),
                    ]),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: TextField(
                    controller: exp,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                        hintText: "Exp",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        suffixIcon: Icon(Boxicons.bx_calendar)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                  press: addNewCard,
                  text: "Agregar",
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
